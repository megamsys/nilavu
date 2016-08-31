/* global intlTelInputUtils */

import Ember from 'ember';
import layout from 'nilavu/components/intl-tel-input';

export default Ember.TextField.extend({
  layout: layout,
  tagName: 'input',
  attributeBindings: ['type'],
  type: 'tel',

  /**
   * When `autoFormat` is enabled, this option will support formatting
   * extension numbers e.g. "+1 (702) 123-1234 ext. 12345".
   *
   * @property allowExtensions
   * @type Boolean
   * @default false
   */
  allowExtensions: false,

  /**
   * Format the number on each keypress according to the country-specific
   * formatting rules. This will also prevent the user from entering invalid
   * characters (triggering a red flash in the input - see
   * [Troubleshooting](https://github.com/Bluefieldscom/intl-tel-input#troubleshooting)
   * to customise this). Requires the utilities script.
   *
   * @property autoFormat
   * @type Boolean
   * @default true
   */
  autoFormat: true,

  /**
   * If there is just a dial code in the input: remove it on blur, and re-add
   * it on focus. This is to prevent just a dial code getting submitted with
   * the form. Requires `nationalMode` to be set to `false`.
   *
   * @property autoHideDialCode
   * @type Boolean
   * @default true
   */
  autoHideDialCode: true,

  /**
   * Add or remove input placeholder with an example number for the selected
   * country. Requires the utilities script.
   *
   * @property autoPlaceholder
   * @type Boolean
   * @default true
   */
  autoPlaceholder: true,

  /**
   * Set the default country by it's country code. You can also set it to
   * `"auto"`, which will lookup the user's country based on their
   * IP address - requires the `geoIpLookup` option - [see example](http://jackocnr.com/lib/intl-tel-input/examples/gen/default-country-ip.html).
   * Otherwise it will just be the first country in the list. **Note that if
   * you choose to do the auto lookup, and you also happen to use the
   * [jquery-cookie](https://github.com/carhartl/jquery-cookie) plugin, it
   * will store the loaded country code in a cookie for future use.**
   *
   * @property defaultCountry
   * @type String
   * @default ""
   */
  defaultCountry: '',

  /**
   * When setting `defaultCountry` to `"auto"`, we need to use a special
   * service to lookup the location data for the user. Write a custom method to
   * get the country code.
   *
   * @property geoIpLookup
   * @type Function
   * @default null
   */
  geoIpLookup: null,

  /**
   * Allow users to enter national numbers (and not have to think about
   * international dial codes). Formatting, validation and placeholders still
   * work. Then you can use `getNumber` to extract a full international
   * number - [see example](http://jackocnr.com/lib/intl-tel-input/examples/gen/national-mode.html).
   * This option now defaults to `true`, and it is recommended that you leave it
   * that way as it provides a better experience for the user.
   *
   * @property nationalMode
   * @type Boolean
   * @default true
   */
  nationalMode: true,

  /**
   * Gets the type of the current `number`. Setting `numberType` when `value`
   * is empty and no custom placeholder is set will affect the format of the
   * auto placeholder. Requires the utilities script.
   *
   * Supported values:
   * - "FIXED_LINE"
   * - "MOBILE"
   * - "FIXED_LINE_OR_MOBILE"
   * - "TOLL_FREE"
   * - "PREMIUM_RATE"
   * - "SHARED_COST"
   * - "VOIP"
   * - "PERSONAL_NUMBER"
   * - "PAGER"
   * - "UAN"
   * - "VOICEMAIL"
   * - "UNKNOWN"
   *
   * @property numberType
   * @type String
   * @default "MOBILE"
   */
  numberType: Ember.computed('number', {
    get() {
      if (this.get('hasUtilsScript')) {

        let typeNumber = this.$().intlTelInput('getNumberType');
        for(let key in intlTelInputUtils.numberType) {
          if (intlTelInputUtils.numberType[key] === typeNumber) {
            return key;
          }
        }

      }

      return 'MOBILE';
    },
    set(key, newValue) {
      if (this.get('hasUtilsScript') && newValue in intlTelInputUtils.numberType) {
        return newValue;
      }

      return 'MOBILE';
    }
  }),

  /**
   * Display only the countries you specify - [see example](http://jackocnr.com/lib/intl-tel-input/examples/gen/only-countries-europe.html).
   *
   * @property onlyCountries
   * @type Array
   * @default "MOBILE"
   */
  onlyCountries: undefined,

  /**
   * Specify the countries to appear at the top of the list.
   *
   * @property preferredCountries
   * @type Array
   * @default ["us", "gb"]
   */
  preferredCountries: ['us', 'gb'],

  /**
   * Specify the format of the `number` property. Requires the utilities
   * script.
   *
   * Supported values:
   * - "E164"          e.g. "+41446681800"
   * - "INTERNATIONAL" e.g. "+41 44 668 1800"
   * - "NATIONAL"      e.g. "044 668 1800"
   * - "RFC3966"       e.g. "tel:+41-44-668-1800"
   *
   * @property numberFormat
   * @type String
   * @default 'E164'
   */
  _numberFormat: 'E164',
  numberFormat: Ember.computed('value', {
    get() {
      return this.get('_numberFormat');
    },
    set(key, newValue) {
      if (this.get('hasUtilsScript') && newValue in intlTelInputUtils.numberFormat) {
        this.set('_numberFormat', newValue);
      }

      return this.get('_numberFormat');
    }
  }),

  /**
   * Get the current number in the format specified by the `numberFormat`
   * property. Note that even if `nationalMode` is enabled, this can still
   * return a full international number. Requires the utilities script.
   *
   * @property number
   * @type String
   * @readOnly
   */
  number: Ember.computed('value', 'numberFormat', {
    get() {
      if (this.get('hasUtilsScript')) {
        let numberFormat = intlTelInputUtils.numberFormat[this.get('numberFormat')];
        return this.$().intlTelInput('getNumber', numberFormat);
      }
    },
    set() { /* no-op */ }
  }),

  /**
   * Get the extension part of the current number, so if the number was
   * "+1 (702) 123-1234 ext. 12345" this would return "12345".
   *
   * @property extension
   * @type String
   * @readOnly
   */
  extension: Ember.computed('number', {
    get() {
      return this.$().intlTelInput('getExtension');
    },
    set() { /* no-op */ }
  }),

  /**
   * Get the country data for the currently selected flag.
   *
   * @property selectedCountryData
   * @type Object
   * @readOnly
   */
  selectedCountryData: Ember.computed('value', {
    get() {
      return this.$().intlTelInput('getSelectedCountryData');
    },
    set() { /* no-op */ }
  }),

  /**
   * Get the validity of the current `number`.
   *
   * @property isValidNumber
   * @type Boolean
   * @readOnly
   */
  isValidNumber: Ember.computed('number', {
    get() {
      return this.$().intlTelInput('isValidNumber');
    },
    set() { /* no-op */ }
  }),

  /**
   * Get more information about a validation error. Requires the utilities
   * scripts.
   *
   * @property isValidNumber
   * @type String
   * @readOnly
   */
  validationError: Ember.computed('number', {
    get() {
      if (this.get('hasUtilsScript')) {
        let errorNumber = this.$().intlTelInput('getValidationError');
        for(let key in intlTelInputUtils.validationError) {
          if (intlTelInputUtils.validationError[key] === errorNumber) {
            return key;
          }
        }
      }
    },
    set() { /* no-op */ }
  }),

  /**
   * Returns whether the untilities script presents.
   *
   * @property hasUtilsScript
   * @type Boolean
   * @readOnly
   */
  hasUtilsScript: Ember.computed({
    get() {
      return (typeof intlTelInputUtils !== 'undefined');
    },
    set() { /* no-op */ }
  }),

  /**
   * Initiate the intlTelInput instance.
   *
   * @method didInsertElement
   */
  didInsertElement() {
    let notifyPropertyChange = this.notifyPropertyChange.bind(this, 'value');

    // let Ember be aware of the changes
    this.$().change(notifyPropertyChange);

    this.$().intlTelInput({
      allowExtensions: this.get('allowExtensions'),
      autoFormat: this.get('autoFormat'),
      autoHideDialCode: this.get('autoHideDialCode'),
      autoPlaceholder: this.get('autoPlaceholder'),
      defaultCountry: this.get('defaultCountry'),
      geoIpLookup: this.get('geoIpLookup'),
      nationalMode: this.get('nationalMode'),
      numberType: this.get('numberType'),
      onlyCountries: this.get('onlyCountries'),
      preferredCountries: this.get('preferredCountries'),
    });
  },

  /**
   * Destroy the intlTelInput instance.
   *
   * @method willDestroyElement
   */
  willDestroyElement() {
    this.$().intlTelInput('destroy');
  },
});
