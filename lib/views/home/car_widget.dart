import 'package:flutter/material.dart';
import 'package:rentapp/views/home/data.dart';

void showCustomDialog(BuildContext context,
    {required String title,
    String okBtnText = "Reservation",
    String cancelBtnText = "Cancel",
    required Function() okBtnFunction}) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          //  content: /* Here add your custom widget  */;
          actions: <Widget>[
            FlatButton(
              //  color: Color(0xff800080),
              child: Text(okBtnText,
                  style: TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.bold,
                  )),
              onPressed: okBtnFunction ,
            ),
            FlatButton(
                child: Text(cancelBtnText),
                onPressed: () => Navigator.pop(context))
          ],
        );
      });
}

Widget buildCar(Car car, int index) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(15),
      ),
    ),
    padding: EdgeInsets.all(16),
    margin: EdgeInsets.only(
        right: index != null ? 16 : 0, left: index == 0 ? 16 : 0),
    width: 220,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            // showCustomDialog(context,
            //     title: 'Not Available', okBtnFunction: () {});
          },
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: BoxDecoration(
                // color: kPrimaryColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Icon(
                  Icons.delete,
                  color: Colors.blue,
                ),
                // Text(
                //   car.condition,
                //   style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 12,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 8,
        // ),
        Container(
          height: 120,
          //width: ,
          child: Center(
            child: Hero(
              tag: car.model,
              child: Image.asset(
                car.images[0],
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 24,
        ),
        Text(
          car.model,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          car.brand,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ),
        Text(
          "per " +
              (car.condition == "Daily"
                  ? "day"
                  : car.condition == "Weekly"
                      ? "week"
                      : "month"),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}
