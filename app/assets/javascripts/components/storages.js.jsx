loadIngredientSuggestionsEditor = function(ingredients) {

var fluxIngredientSuggestionsStore = {};

fluxIngredientSuggestionsStore.constants = {
  UPDATE_INGREDIENT: "UPDATE_INGREDIENT",
  DELETE_INGREDIENT: "DELETE_INGREDIENT",
};

  /* Define the Fluxxor store (above) */
  /* ... */
  fluxIngredientSuggestionsStore.store = Fluxxor.createStore({
  initialize: function(options) {
    /* We'll have ingredients */
    this.ingredients = options.ingredients || [];
    /* Those ingredients can be updated and deleted */
    this.bindActions(fluxIngredientSuggestionsStore.constants.UPDATE_INGREDIENT, this.onUpdateIngredient, fluxIngredientSuggestionsStore.constants.DELETE_INGREDIENT, this.onDeleteIngredient);
  },
  getState: function() {
    /* If someone asks the store what the ingredients are, show them */
    return {
      ingredients: this.ingredients,
    };
  },
  onUpdateIngredient: function(payload) {
    /* Update the model if an ingredient is renamed */
    payload.ingredient.item = payload.new_name;
    this.emit("change")
  },
  onDeleteIngredient: function(payload) {
    /* Update the model if an ingredient is deleted */
    this.ingredients = this.ingredients.filter(function(ingredient) {
      return ingredient.id != payload.ingredient.id
    });
    this.emit("change");
  }
});

fluxIngredientSuggestionsStore.store = Fluxxor.createStore({
  initialize: function(options) {
    /* We'll have ingredients */
    this.ingredients = options.ingredients || [];
    /* Those ingredients can be updated and deleted */
    this.bindActions(fluxIngredientSuggestionsStore.constants.UPDATE_INGREDIENT, this.onUpdateIngredient, fluxIngredientSuggestionsStore.constants.DELETE_INGREDIENT, this.onDeleteIngredient);
  },
  getState: function() {
    /* If someone asks the store what the ingredients are, show them */
    return {
      ingredients: this.ingredients,
    };
  },
  onUpdateIngredient: function(payload) {
    /* Update the model if an ingredient is renamed */
    payload.ingredient.item = payload.new_name;
    this.emit("change")
  },
  onDeleteIngredient: function(payload) {
    /* Update the model if an ingredient is deleted */
    this.ingredients = this.ingredients.filter(function(ingredient) {
      return ingredient.id != payload.ingredient.id
    });
    this.emit("change");
  }
});

fluxIngredientSuggestionsStore.actions = {
  updateIngredient: function(ingredient, new_name) {
    /* First, update the model by calling the function above */
    this.dispatch(fluxIngredientSuggestionsStore.constants.UPDATE_INGREDIENT, {
      ingredient: ingredient,
      new_name: new_name
    });
    /* Then, update the server and show a success message */
    $.ajax({
      type: "PUT",
      url: "/ingredient_suggestions/" + ingredient.id,
      data: {
        item: new_name
      },
      success: function() {
        $.growl.notice({
          title: "Ingredient suggestion updated",
        });
      },
      failure: function() {
        $.growl.error({
          title: "Error updating ingredient suggestion",
        });
      }
    });
  },
  deleteIngredient: function(ingredient) {
    /* First, update the model by calling the function above */
    this.dispatch(fluxIngredientSuggestionsStore.constants.DELETE_INGREDIENT, {
      ingredient: ingredient
    });
    /* Then, delete it on the server and show a success message */
    $.ajax({
      type: "DELETE",
      url: "/ingredient_suggestions/" + ingredient.id,
      success: function(data) {
        $.growl.notice({
          title: "Ingredient suggestion deleted",
        });
      }.bind(this),
      failure: function() {
        $.growl.error({
          title: "Error deleting ingredient suggestion",
        });
      }
    });
  }
};

fluxIngredientSuggestionsStore.init = function(ingredients) {
  var tempStore = {
    IngredientSuggestionsStore: new fluxIngredientSuggestionsStore.store({
      ingredients: ingredients
    })
  };
  fluxIngredientSuggestionsStore.flux = new Fluxxor.Flux(tempStore, fluxIngredientSuggestionsStore.actions);
}


  /* Define the React components (above) */
  /* ... */

  var IngredientSuggestionsEditor = React.createClass({
  /* Update this component when the Fluxxor store is updated */
  mixins: [FluxMixin, StoreWatchMixin("IngredientSuggestionsStore")],
  /* Get the ingredients list from the store */
  getStateFromFlux: function() {
    var flux = this.getFlux();
    return {
      ingredients: flux.store("IngredientSuggestionsStore").getState().ingredients
    };
  },
  /* Show each ingredient when the IngredientSuggestion component */
  render: function() {
    var props = this.props;
    var ingredients = this.state.ingredients.map(function (ingredient) {
      return <IngredientSuggestion ingredient={ingredient} key={ingredient.id} flux={props.flux} />
    });
    return (
      <div>
        {ingredients}
      </div>
    );
  }
});


var IngredientSuggestion = React.createClass({
  /* We need this mixin since we are calling Flux store actions from this component */
  mixins: [FluxMixin],
  /* We'll track two things for each ingredient, whether the user has changed its name and whether they have saved the update to the server. */
  getInitialState: function() {
    return {changed: false, updated: false};
  },
  render: function() {
    return (
      <div>
        <a href="#" onClick={this.handleDelete}><i className="fa fa-times"></i></a>
        <input onChange={this.handleChange} ref="ingredient" defaultValue={this.props.ingredient.item}/>
        {/* Show the Update and Cancel buttons only if the user has changed the ingredient name */
          this.state.changed ?
          <span>
            <a href="#" onClick={this.handleUpdate}>Update</a>
            <a href="#" onClick={this.handleCancelChange}>Cancel</a>
          </span>
        :
          ""
        }
      </div>
    )
  },
  handleChange: function() {
    /* If the user changed the ingredient name, set the 'changed' state to true */
    if ($(this.refs.ingredient.getDOMNode()).val() != this.props.ingredient.item) {
      this.setState({changed: true});
    } else {
      this.setState({changed: false});
    }
  },
  handleUpdate: function(e) {
    /* Update the ingredient name in the Fluxxor store */
    e.preventDefault();
    this.getFlux().actions.updateIngredient(this.props.ingredient, $(this.refs.ingredient.getDOMNode()).val());
    this.setState({changed: false, updated: true});
  },
  handleDelete: function(e) {
    /* Delete the ingredient from the Fluxxor store */
    e.preventDefault();
    if (confirm("Delete " + this.props.ingredient.item + "?")) {
      this.getFlux().actions.deleteIngredient(this.props.ingredient);
    }
  },
  handleCancelChange: function(e) {
    e.preventDefault();
    $(this.refs.ingredient.getDOMNode()).val(this.props.ingredient.item);
    this.setState({changed: false});
  }
});

  /* Load the Fluxxor store and render React components to the page */
  fluxIngredientSuggestionsStore.init(ingredients);
  React.render(<IngredientSuggestionsEditor flux={fluxIngredientSuggestionsStore.flux} />,
    document.getElementById('js-ingredient-suggestions-editor'));

}
