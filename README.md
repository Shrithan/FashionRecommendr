# FashionRecommendr
A recommendation engine for your fashion needs.


Please go to the deeplabv3_model_link.txt file in python/scripts

How to run:
1. Download all the libraries for python in the requirements.txt file in the python folder
2. Register for gemini API and get the key and put it Test.py 
3. Run the app.py file before you run the flutter website.
4. Run python3 path/to/your/app.py   
5. Install flutter sdk
6. Now run the command "flutter run" in terminal. Make sure you are in the app folder before running the command.
7. Make sure to run the command in the same folder as the pubspec.yaml file


/FashionRecommendr/app/lib/pages/Showing_Results.dart:
  --> Change line 10 and 11, add the path of the imageurls and links .txt files in the assets folder.

/FashionRecommendr/python/app.py:
  --> Change line 17, add the path of the uploads folder present in app. Make sure to remove the Remove.txt file
  -->(Only after going through deeplabv3_model_link.txt) Change line 190, add the path of the downloaded deeplabv3 model.

/FashionRecommendr/python/Test.py:
  --> Change line 234, add the path of the imageurls.txt file in the assets folder.
  --> Change line 238, add the path of the links.txt file in the assets folder.
