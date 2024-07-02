# Work Items

## Task 1

As a user I want to view a list of all my Accounts so that I can choose which
one to perform a Round-Up on.

### Acceptance Criteria

* Can view list of Accounts
* Each Account item shows:
  * Name
  * Account Balance
* Show error message if Account list cannot be loaded
* Allow the user to retry loading their Account list if there was an error

## Task 2

As a user I want to view an Account so that I can perform a Round-Up on it.

### Acceptance Criteria

* Can navigate to the Account view from the Account List view
* Account name is shown
* Account balance is shown
* Allow the user to navigate back to the Account list view
* Show error message if account details cannot be loaded
* Allow the user to retry loading their account if there was an error

## Task 3

As a user I want to view my Savings Goals so I can see where I can transfer my
Round-Up amount to.

### Acceptance Criteria

* Can navigate to Savings Goals view from Account View
* Can view list of Savings Goals
* Each savings goal item shows:
  * Name
  * Current amount
  * Goal amount
* When no Savings Goals, should show a message saying the user has no Saving
Goals
* Allow the user to navigate back to the Account view
* Show error message if Savings Goals cannot be loaded
* Allow the user to retry loading their Savings Goals if there was an error

## Task 4

As a user I want to create a new Savings Goal from the Savings Goal view so I
transfer my Round-Up amount into it.

### Acceptance Criteria

* User can action presenting a form to input Savings Goals details from the
Savings Goals view
* Fields
  * Savings Goal Name
  * Savings Goal Target
* User can save the new Savings Goal if validation passes
* Validation:
  * Name must not be empty and alpha-numeric text
  * Target must not be empty
  * Target must be a positive number
  * Target to have a maximum of 2 decimal places
* User is taken back to their Account's Savings Goals when created successfully
* Show error message if the new Savings Goal cannot be created
* User can dismiss the form without creating a new Savings Goal

## Task 5

As a user I want to view my Round-Up amount for a week so that I can decide
whether to transfer the amount into a Savings Goal.

### Acceptance Criteria

* User can interact with a Call-To-Action on the Account view to display the Round-Up for a week
* Initial/default week is the current week
* User can change the selected week to the current week or any week in the past
* User cannot select a week in the future
* The default Savings Goal to transfer to is the user's first Savings Goal
* Allow the user to select a Savings Goal
* If the user has no Savings Goal, display a blank selection
* The following information is displayed
  * The Round-Up amount for the selected week
  * The date of the first day of selected week
  * The selected Savings Goal
  * The current balance of the user's Account
* A Call-To-Action to make the transfer
* Validation:
  * A valid week must be selected
  * A Saving Goal must be selected
  * The user must have a balance on their Account greater than the Round-Up amount

## Task 6

As a user I want to transfer my Round-Up amount to a Savings Goal so that I can
save money towards this goal.

### Acceptance Criteria

* Interacting with the Call-To-Action of the Round-Up view makes the transfer
* User must confirm they want to make the transfer after interacting with the
Call-To-Action
* On successfully transfer user is shown a message informing them so, including:
  * Amount transferred
  * The Savings Goal it was transferred to
  * Summary of the Savings Goal
    * Amount so far
    * Target
* User can dismiss the view and return to the Account view
* Show error message if the transfer failed
