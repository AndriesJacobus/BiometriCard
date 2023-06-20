# BiometriCard

Safest way to keep track of your cards locally.

Safe, encrypted, open source, biometric-secured, locally safed bank card saving.
Lets break that down...

## BiometriCard Top-Level Features

### Local Biometric Authentication Secured
In order to read cards stored in SecureStorage, the app allows users to authenticate using their local biometrics set up through the OS itself.
In the case that biometrics are supported by the device, but not configured, the app falls back to password authentication.
In the case that biometrics are _not_ supported by the device, no authentication is required.

### Retrieve, Cache, and List stored cards
After the auth step, all stored cards are loaded form Secure Storage and cached in memory via the `secure_storage_service.dart`.
This is then listed for the user on the Home Screen using `Virtual Cards`.

### Virtual Cards
Cards are represented on the app as Virtual Cards, on which the user is able to see all the information captured about the cards.
Cards also have a 3D spin to them, with which users can intuitively view teh back of their card where their CVV number is listed (as on physical cards).

### New Card View and Capturing
Using the FAB at the bottom right of the screen, the user is able tom, at any stage, open a bottom sheet and capture new card details.
The details of the newly captured card is presented to the user in a live Virtual Card as they enter their details.

When saving a card, the details of the card is validated to make sure that they are applicable, and that the captured card isn't a duplicate.

### Card Detail Copying
User can easily copy the details of their Virtual Cards (once they have passed authentication - if applicable).
This is super useful for when users need to enter their card details like for online payments. 

### Scan Card Details
_Coming soon..._

### Card Country Blacklist
_Coming soon..._

## BiometriCard Cool Tech Specification
Mixins, models, and more!

## Geting the Project Started

In order to get the project started:

1. Clone the repo's `master` branch:
```
git clone git@github.com:AndriesJacobus/BiometriCard.git
``` 

2. Get flutter setup:
```
flutter pub get;
flutter run;
```

For this step to work, it is recommended to already have a simulator or compatible device connected and running.

---

**Made with 💚 by _<u><a href = "https://github.com/andriesjacobus" target = "_blank" style = "color: green;">Andries Jacobus du Plooy</a></u>_**