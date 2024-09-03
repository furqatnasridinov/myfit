# myfit

App divided into 4 folders to keep code clean and more redable. 
- application
- domain
- infrastructure 
- presentation

We used riverpod for state management, all logic of riverpod is written in application folder.Each feature is divided in 4 file : 
For example registration : 
- registration notifier (business logic and state managing are there)
- registration state (all variables of this component we declare here)
- registration state freezed (generated file from registration state)
- registration provider (for accesing provider)

For navigation used auto_route package and for di used get_it.

Also used fcm for push notifications & depplinking with app_links.


Utils are in services folder shared prefs logic for local storage and many more helper functions are in apphelpers.dart file.


**** THEHRE ARE ALSO MANY MORE COMMENTS IN CODE WHERE NEEDED ****