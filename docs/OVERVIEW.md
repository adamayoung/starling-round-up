# Project Overview and Considerations

## High level description

Build a round up feature to transfer rounded-up amounts of out going
transactions into a 'Savings Goal'.

## Out of Scope

* Providing a means for a user to authenticate in the app
  * an access token will be provided for this project in code
* Providing a detailed list of Account transactions in the app
  * this challenge concerns the Round-Up feature only
* SSL Certificate-Pinning
  * as this challenge/app will not be used in a production environment it is unnecessary

## Assumptions

* A user will have a sandboxed account set up
* The user can generate and provide an access token
* The user will not have a Savings Goal setup on their Account
* When choosing the start and end date of a week for a Round-Up, Monday will
be assumed to be the start of the week
* The user will not have an overdraft on their Account, so will not be able to
transfer a Round-Up if their Account does not have a balance greater that the
Round-Up amount.
* The App will be run on iPhone only - therefore, the app will not adapt for
larger screen sizes on iPad
* App Localisation - this app will only be available in English

## Further Assumptions Made During Implementation

* If a transaction is an amount of exactly a whole major unit e.g. £1.00, then
the Round-Up amount will be zero.

## iOS Version Support

iOS Version: iOS 16+

As of 9th June 2024 Apple report that out of all iPhone devices running iOS:

| OS Version | Percentage of users |
| ---------- | ------------------- |
| iOS 17     | 77%                 |
| iOS 16     | 14%                 |
| Earlier    | 9%                  |

Source: [Apple - iOS and iPadOS usage](https://developer.apple.com/support/app-store/)

Having a minimum deployment of iOS 16 would mean 91% of users would have the
required iOS version to run this app.

## Security Considerations

As we're dealing with customers' financial data, security should be a priority from the start.

Therefore,

* HTTPS will be used when making requests to APIs
  * SSL certificate-pinning would normally used to further enhance security
  with APIs (see [Out of Scope](#out-of-scope))
* No user data should be stored on device
* The use of third-party libraries/frameworks should be at an absolute
minimum. Ideally none should be used to avoid any potential security threats.

## Other Considerations

### Multiple Round-Up Transfers for a Week

There seems to be no way of knowing/storing/flagging what transactions have
been used in a Round-Up transfer. Therefore, it would be possible to make
multiple Round-Up transfers for the same week.

A possible solution would be to store the transaction identifiers of
transactions used in a Round-Up transfer locally on device, but this doesn't
seem practical and may introduce security concerns (see
[Security Considerations](#security-considerations)).
