FactoryGirl.define do
  trait :assemblies_resource do
    skip_create

    initialize_with do
      new.class.construct_from_response(attributes)
    end

    ignore do
      balanced_marketplace_uri { ENV["BALANCED_MARKETPLACE_URI"] }
    end

    id { SecureRandom.urlsafe_base64(24).delete("-_").first(24) }
  end

  factory :balanced_card, class: Balanced::Card do
    balanced_resource

    account nil
    brand "MasterCard"
    card_type "mastercard"
    country_code nil
    created_at { Time.current.xmlschema(6) }
    customer nil
    expiration_month 12
    expiration_year 2020
    hash { SecureRandom.hex(32) }
    is_valid true
    is_verified true
    last_four "5100"
    meta({})
    name nil
    postal_code nil
    postal_code_check "unknown"
    security_code_check "passed"
    street_address nil
    uri { "#{balanced_marketplace_uri}/cards/#{id}" }
  end

  factory :balanced_bank_account, class: Balanced::BankAccount do
    balanced_resource

    account_number "xxxxxx0001"
    bank_name "BANK OF AMERICA, N.A."
    can_debit false
    created_at { Time.current.xmlschema(6) }
    credits_uri { "#{uri}/credits" }
    customer nil
    debits_uri { "#{uri}/debits" }
    fingerprint { SecureRandom.hex(32) }
    meta({})
    name "Johann Bernoulli"
    routing_number "121000358"
    type "checking"
    uri { "/v1/bank_accounts/#{id}" }
    verification_uri nil
    verifications_uri { "#{uri}/verifications" }
  end
end
