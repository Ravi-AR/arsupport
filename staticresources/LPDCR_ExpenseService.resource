(function () {
    'use strict';

    angular
        .module('app')
        .service('expenseService', expenseService);

    expenseService.$inject = ['vfRemote', '$q'];
    function expenseService(vfRemote, $q) {



        var current = {
            account: null,
            category: null,
            subCategory: null,
            rules: {},
            expenseId: null,
            lineItems: [],
            date: null

        },
            accounts = [],
            currentCategory = null,
            categories = [],
            currentSubCategory = null,
            subCategories = [],
            currentRules = null,
            currentExpenseId = null;



        var service = {
            current: current,
            accounts: accounts,
            categories: categories,
            subCategories: subCategories,

            init: init,
            saveExpense: saveExpense,
            saveExpenseLineItem: saveExpenseLineItem,
            setAccount: setAccount,
            getAllCategories: getAllCategories,
            getSubCategories: getSubCategories,
            getSubCategoriesSettings: getSubCategoriesSettings,
            setCategory: setCategory,
            setSubCategory: setSubCategory,

        };

        //init();

        return service;

        ////////////////

        function getAllCategories() {
            var deferred = $q.defer();

            vfRemote.LPDCR_ExpenseEditController.getAllCategories()
                .then(function (result) {

                    console.log('getAllCategories');
                    console.log(result);

                    if (result) {
                        var jsonResults = JSON.parse(result);
                        deferred.resolve(jsonResults.Categories);
                    }
                })
                .catch(function (event) {
                    deferred.reject(event);
                });

            return deferred.promise;
        }

        function getSubCategories(category) {
            var deferred = $q.defer();

            vfRemote.LPDCR_ExpenseEditController.getSubCategories(category)
                .then(function (result) {

                    console.log('getSubCategories');
                    console.log(result);

                    var jsonResults = JSON.parse(result);
                    var end = jsonResults.subCategories;
                    deferred.resolve(end);
                })
                .catch(function (event) {
                    deferred.reject(event);
                });

            return deferred.promise;
        }

        function getSubCategoriesSettings(subCategory) {

            var deferred = $q.defer();

            vfRemote.LPDCR_ExpenseEditController.getAmountBySubCategories(subCategory)
                .then(function (result) {


                    console.log('getSubCategoriesSettings');
                    console.log(result);

                    if (result) {
                        var jsonResults = JSON.parse(result);
                        deferred.resolve(jsonResults);
                    } else {
                        deferred.resolve();
                    }
                })
                .catch(function (event) {
                    deferred.reject(event);
                });

            return deferred.promise;
        }

        function saveExpense() {
            var deferred = $q.defer();
            vfRemote.LPDCR_ExpenseEditController.saveExpense(this.current.account.id, this.current.description)
                .then(function (result) {

                    console.log('saveExpense');
                    console.log(result);
                    service.current.expenseId = result;
                    deferred.resolve(result);
                })
                .catch(function (event) {
                    deferred.reject(event);
                });

            return deferred.promise;
        }

        function saveExpenseLineItem(lineItem) {

            var deferred = $q.defer();
            
            function action() {
                console.log('lineitem' + JSON.stringify(lineItem));
                console.log('this' + JSON.stringify(this));
                console.log('service' + JSON.stringify(service));

                /*
                alert(service.current.expenseId);
                alert(lineItem.amountSpent);
                alert(service.current.description);
                alert(service.current.category);
                alert(lineItem.date);
                alert(service.current.subCategory);
                */
                var currentItemId = null;
                if(lineItem.id != undefined){
                    currentItemId = lineItem.id;
                }

                vfRemote.LPDCR_ExpenseEditController.saveLineItem(currentItemId, service.current.expenseId, lineItem.amountSpent, service.current.description,service.current.category, lineItem.date,service.current.subCategory).then(function (result) {

                        console.log('saveExpenseLineItem');
                        console.log(result);

                        lineItem.id = result;

                        service.current.lineItems.push(lineItem);

                        deferred.resolve(result);
                    })
                    .catch(function (event) {
                        deferred.reject(event);
                    });
            }

            if (service.current.expenseId) {
                action();

            } else {
                service.saveExpense()
                    .then(function () {
                        action();
                    })
            }

            return deferred.promise;
        }

        function setAccount(account) {
            this.current.account = account;
        }

        function setCategory(category) {

            var deferred = $q.defer();
            service.current.category = category;
            service.getSubCategories(category)
                .then(function (results) {
                    service.subCategories = results;
                    //service.setSubCategory(service.subCategories[0]);
                    service.setSubCategory(null);
                    deferred.resolve();
                });
            return deferred.promise;
        }

        function setSubCategory(subCategory) {
            service.current.subCategory = subCategory;
            if (service.current.subCategory) {

                service.getSubCategoriesSettings(subCategory)
                    .then(function (results) {
                        service.current.rules = null;
                        service.current.rules = results;

                        service.current.rules.submitLabelText = 'Total Amount Spent: $';

                        if (service.current.rules.CheckpointMultiplier) {
                            service.current.rules.submitLabelText = 'Total Submited:';
                        }
                        if (!service.current.rules.ReimbursementPercentage) {
                            service.current.rules.ReimbursementPercentage = 100;
                        }

                    })
                    .catch(function () {

                        service.current.rules = null;
                    });
            } else {

                service.current.rules = null;
            }
        }


        function init() {

            var deferred = $q.defer();

            //TODO Remove after testing complete
            service.accounts = [
                { name: 'WALKTHROUGH DEALER', id: '001R0000018j2tN' },
                { name: "account two" },
                { name: "account three" },
                { name: "account four" },
            ];

            current.account = service.accounts[0];
            // current.category = 'Trials';
            // current.subCategory = 'Trials TBD';
            // current.rules = {
            //     "Id": "a3RR00000007QHFMA2",
            //     "Name": "Multi-brand Advertising",
            //     "ReimbursementPercentage": 50.0,
            //     "Category": "Local - Event materials",
            //     "Description": "- Used in the Animal Count & Lifestage trigger. <br/>- Acts as a rollup summary to populate the total amount of Animals for each Lifestage and Animal Type <br/>- Used to calculate the amount of Annual Points on the opportunity based on the Lifestage selected for the Opportunity"
            // };
            // current.expenseId = 'a3KR0000000FFAMMA4';
            // current.lineItems = [
            //     {
            //         amountRequested: "333.00",
            //         amountSpent: 333,
            //         description: "asd",
            //         id: "a3LR0000000EqysMAC",
            //         type: 'Expense'
            //     },
            //     {
            //         amountRequested: "333.00",
            //         amountSpent: 333,
            //         description: "asd",
            //         id: "a3LR0000000EqysMAC",
            //         type: 'Expense'
            //     },
            //     {
            //         amountRequested: "333.00",
            //         amountSpent: 333,
            //         description: "asd",
            //         id: "a3LR0000000EqysMAC",
            //         type: 'Expense'
            //     },
            //     {
            //         amountRequested: "333.00",
            //         amountSpent: 333,
            //         description: "asd",
            //         id: "a3LR0000000EqysMAC",
            //         type: 'Expense'
            //     }
            // ];

            // END: Remove

            service.current.account = service.accounts[0];

            service.getAllCategories()
                .then(function (results) {

                    service.categories = results;
                    service.setCategory(service.categories[0])
                        .then(function () {
                            service.setSubCategory(service.subCategories[0]);
                            deferred.resolve();
                        });
                })
                .catch(function (error) {
                    deferred.reject(error);
                });


            return deferred.promise;
        }
    }


})();