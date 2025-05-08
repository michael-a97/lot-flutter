# lot_flutter

<div style="display:flex; flex-direction:column; align-items:center;">

<svg height="619.52" style="width:250; height:250" viewBox="745 516.36 563 464.64" width="563pt" xmlns="http://www.w3.org/2000/svg" fill="white"><clipPath id="a"><path d="M745 516.36h563V981H745z"/></clipPath><g clip-path="url(#a)"><path d="M875.68 884.2H759.52V596.22h56.87v234.74h59.29zM987 886.62q-18.392 0-34.364-5.687-15.972-5.687-28.556-15.367-13.068-9.68-22.869-22.748-9.801-13.068-15.367-30.492-5.324-15.972-5.324-34.122 0-17.424 5.324-33.638t15.004-29.524q10.164-13.794 23.595-23.474t28.677-14.762q7.986-2.662 16.456-4.114 8.47-1.452 17.424-1.452 17.182 0 33.517 5.566 16.335 5.566 29.403 15.004 12.826 9.68 22.869 23.111 10.043 13.431 15.367 29.645 2.42 7.986 3.872 16.456 1.452 8.47 1.452 17.182 0 14.52-4.477 31.218t-16.093 32.912q-9.68 13.552-23.232 23.474t-29.04 15.246q-7.986 2.662-16.456 4.114-8.47 1.452-17.182 1.452zm.242-52.03q7.986 0 16.093-2.662t14.399-7.986q7.986-6.292 12.463-13.673 4.477-7.381 6.171-13.673 1.21-4.114 1.936-8.591.726-4.477.726-9.075 0-9.438-2.662-17.787-2.662-8.349-7.26-15.367-4.114-5.808-10.406-11.253-6.292-5.445-15.246-8.591-7.986-2.662-16.214-2.662-17.424 0-30.734 10.406-6.292 4.84-11.374 11.979-5.082 7.139-7.502 15.367-1.21 4.114-1.936 8.712t-.726 9.196q0 7.502 2.178 15.972 2.178 8.47 7.986 16.94 4.598 6.776 10.89 11.858 6.292 5.082 14.762 7.986 7.986 2.904 16.456 2.904zm134.068-211.75h54.45v14.036q0 26.862-21.538 37.752v3.872q10.648-4.84 22.99-4.84h38.478v50.82h-39.93v100.43q0 7.26 7.26 7.26h32.67l2.42 52.03h-48.4q-9.68 0-17.424-1.936t-13.552-5.808q-5.808-3.388-9.68-9.438-3.872-6.05-5.808-13.31-1.936-7.744-1.936-17.424V724.48h-19.36v-50.82h19.36zm144.232 263.78q-5.324 0-10.769-1.694t-9.317-4.84q-4.356-3.146-7.381-7.26-3.025-4.114-4.719-9.438-1.936-5.324-1.936-10.648 0-6.05 1.936-11.011 1.936-4.961 4.84-9.075 3.146-4.598 7.26-7.381 4.114-2.783 9.438-4.719 5.324-1.694 10.648-1.694t10.89 1.815q5.566 1.815 9.196 4.477 3.872 3.146 6.776 7.018t5.082 9.68q1.694 5.566 1.694 10.89 0 4.84-1.694 10.648t-4.598 9.438q-3.146 4.114-7.381 7.381-4.235 3.267-9.317 4.719-2.42.726-5.082 1.21t-5.566.484z"/></g></svg>

![contributors-url]
![stars-url]
![license-url]
![flutter-url]
![dart-url]
[![linkedin-shield]][linkedin-url]

[contributors-url]:https://img.shields.io/github/contributors/michael-a97/lot-flutter?style=for-the-badge

[stars-url]:https://img.shields.io/github/stars/michael-a97/lot-flutter?style=for-the-badge

[license-url]:https://img.shields.io/github/license/michael-a97/lot-flutter?style=for-the-badge

[flutter-url]: https://img.shields.io/badge/Flutter-v3.29.3-blue?style=for-the-badge&logo=flutter&logoColor=white

[dart-url]: https://img.shields.io/badge/Dart-v3.7.2-blue?style=for-the-badge&logo=dart&logoColor=white

[linkedin-shield]: https://img.shields.io/badge/linkedin-%230077B5.svg?style=for-the-badge&logo=linkedin&logoColor=white

[linkedin-url]:https://www.linkedin.com/in/michael-asnake/
</div>

Lot is a system targeted at making finding parking spaces easier for users and managing parking spaces easier
for parking space owners & attendants. The app is built with flutter and currently supports the iOS and Android
platforms.
<br/>
<hr/>

## Features

### For customers

- [x] **User Registration**: Users can register and create an account.
- [x] **User Authentication**: Users can create accounts and log in securely.
- [ ] **User Profile Management**: Users can manage their profiles, and vehicle description
- [ ] **Search for parking spaces**
    - [ ] Search for nearby parking spaces
    - [ ] Display essential details, such as location, availability, and pricing
- [ ] **Real-time parking information**
    - [ ] show how long the customer has been parked

### For parking space attendants

- [ ] **Manage parking spaces**
    - [ ] update parking spaces
- [ ] **Manage parking sessions**
    - [ ] Log the start and end times of parking sessions

<br/>
<hr/>

## Major packages used

| Package                                                                                                           | Usage                                                       |
|-------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------|
| [**very_good_cli**](https://pub.dev/packages/very_good_cli)                                                       | Managing multiple local packages, & running unit tests      |
| [**auto_route**](https://pub.dev/packages/auto_route)                                                             | Routing                                                     |
| **[get_it](https://pub.dev/packages/get_it), [injectable](https://pub.dev/packages/injectable)**                  | Dependency Injection                                        |
| **[bloc](https://pub.dev/packages/bloc), [flutter_bloc](https://pub.dev/packages/flutter_bloc)**                  | State management                                            |
| **[**drift**](https://pub.dev/packages/drift)**                                                                   | Local database                                              |
| [**dio**](https://pub.dev/packages/dio)                                                                           | HTTP client                                                 |
| [**dartz**](https://pub.dev/packages/dartz)                                                                       | Functional programming                                      |
| [**formz**](https://pub.dev/packages/formz)                                                                       | Form Validation                                             |
| [**firebase_auth**](https://pub.dev/packages/firebase_auth)                                                       | Firebase Phone Authentication for phone number verification |
| **[flutter_localizations](https://pub.dev/packages/flutter_localization), [intl](https://pub.dev/packages/intl)** | Localization & Internationalization                         |
| [**flutter_secure_storage**](https://pub.dev/packages/flutter_secure_storage)                                     | Encrypted local storage                                     |

<br/>
<hr/>

## Issues and Contributions

Please use the [**issue tracker**](https://github.com/michael-a97/lot-flutter/issues) for report bugs or add feature requests in the issue tracker. Please follow the issue template and
PR request template when submitting issues and PRs.
