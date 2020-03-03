# Adventuro
## iOS elective course - final project presented at university

The project reflects skills I aquired while attending iOS elective at university.
The application is coded in Swift and has connection to Firebase authentication and Cloud Firestore (NoSQL database).

### principle of the application
An imaginary person travels the world. She or he goes to location, let's say Nyhavn in Denmark or Plitvice Lakes in Croatia.
If the user downloaded Adventuro, he/she can scan a QR code at the location and get valuable information about the place as well as photo of the place.

Furthermore, after seeing photo and description of the place, the user is able to take a selfie from this location, and save it to his personal collection of the places so when he or she opens the application, all locations wich were scanned via QR code are available (Tableview). After clickling particular location, the user is able to see his adventure in a form of location description and his selfie. 

All data are saved in the database. My NoSQL Firestore has therefore two collections: "Users" and "Locations"


