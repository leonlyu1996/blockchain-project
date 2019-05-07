App_kaggle = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    // Load competitions.
    // Load the list of competitions from contracts / json file
    // Insert it on front end

    return await App_kaggle.initWeb3();
  },

  initWeb3: async function() {
    // Modern dapp browsers...
    if (window.ethereum) {
      App_kaggle.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App_kaggle.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App_kaggle.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App_kaggle.web3Provider);

    return App_kaggle.initContract();
  },

  initContract: function() {
    // $.getJSON('Adoption.json', function(data) {
    //   // Get the necessary contract artifact file and instantiate it with truffle-contract
    //   var AdoptionArtifact = data;
    //   App_kaggle.contracts.Adoption = TruffleContract(AdoptionArtifact);
    //
    //   // Set the provider for our contract
    //   App_kaggle.contracts.Adoption.setProvider(App_kaggle.web3Provider);
    //
    //   // Use our contract to retrieve and mark the adopted pets
    //   return App_kaggle.markAdopted();
    // });

    return App_kaggle.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-create', App_kaggle.handleCreate);
  },

  handleCreate: function(event) {
    event.preventDefault();

  //   var petId = parseInt($(event.target).data('id'));
  //
  //   var adoptionInstance;
  //
  //   web3.eth.getAccounts(function(error, accounts) {
  //     if (error) {
  //       console.log(error);
  //     }
  //
  //     var account = accounts[0];
  //
  //     App_kaggle.contracts.Adoption.deployed().then(function(instance) {
  //       adoptionInstance = instance;
  //
  //       // Execute adopt as a transaction by sending account
  //       return adoptionInstance.adopt(petId, {from: account});
  //     }).then(function(result) {
  //       return App_kaggle.markAdopted();
  //     }).catch(function(err) {
  //       console.log(err.message);
  //     });
  //   });
  // }
  }
}

$(function() {
  $(window).load(function() {
    App_kaggle.init();
  });
});
