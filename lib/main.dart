import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      title: 'A Simple Interest Calculator App',
      debugShowCheckedModeBanner: false,
      home: SIForm(),
      theme: ThemeData(
        primaryColor: Colors.indigo,
            accentColor: Colors.indigoAccent,
        brightness: Brightness.dark


      ),
      //SIForm() is a stateful widget that we must create
    )
  );
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }

}

class _SIFormState extends State<SIForm>{
  //defining form key
  var _formKey = GlobalKey<FormState>();


  var _currencies = ['RTGS', 'Dollars', 'Pounds'];
  //to provide a constant padding throughout use a var
  final _minimumPadding = 5.0;

  var _currentItemSelected = 'RTGS';

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  //
  var displayResult = '';


  @override
  Widget build(BuildContext context) {
   TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Simple Interest Calculator by Mqhezoe'),
      ),
      
      //adding a common margin to the container 
      body: Form(
        key: _formKey,
       // margin:
        //but the Form widget doesnt contain the margin property but we have to
        //give it some how, for that let's wrap our ListView in a child widget
        child: Padding (
          padding: EdgeInsets.all(_minimumPadding*2),
        //child: Column(
          child: ListView(
          children: <Widget>[
            //return the widget from our column as a first child
            getImageAsset(),

         //to add space between the textfield widgets wrap both textfields
            //inside the padding widget
            Padding(
                padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
                child:TextFormField (
              //to enable the user to enter a number
              keyboardType: TextInputType.number,
              style: textStyle,
              controller: principalController,
              validator: (String value){
                if (value.isEmpty){
                  return 'Please enter principal amount';
                }
              },
              decoration: InputDecoration(
                labelText: 'Principal',
                hintText: 'Enter Principal e.g. 12000',
                  hintStyle: textStyle,
                  errorStyle: TextStyle(
                    color: Colors.yellowAccent,
                        fontSize: 15.0
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)
                  )
              ),
            )),
            Padding(
              padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
              child:TextFormField (
              //to enable the user to enter a number
              keyboardType: TextInputType.number,
              style: textStyle,
              controller: roiController,
              //adding the validation layer
              validator: (String value){
                if(value.isEmpty){
                  return 'Please enter rate of interest';
                }
              },
              decoration: InputDecoration(
                  labelText: 'Rate of Interest',
                  hintText: 'In percent',
                  hintStyle: textStyle,
                  errorStyle: TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 15.0
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0)
                  )
              ),
            )),
            Padding(
              //add the padding
                padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
                child:Row(
              children: <Widget>[
                //first element is the textfield so simply copy the code
                //for implementing a textfield
                Expanded(
                    child:TextFormField (
                  //to enable the user to enter a number
                  keyboardType: TextInputType.number,
                  style: textStyle,
                  controller: termController,
                      validator: (String value){
                        if (value.isEmpty){
                          return 'Please enter time in years';
                        }
                      },
                  decoration: InputDecoration(
                      labelText: 'Term',
                      hintText: 'Time in years',
                      hintStyle: textStyle,
                      errorStyle: TextStyle(
                          color: Colors.yellowAccent,
                          fontSize: 15.0
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0)
                      )
                  ),
                )),

                Container (width: _minimumPadding * 5,),

                Expanded(child:DropdownButton<String>(
                  items: _currencies.map((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                    }).toList(),

                   value: _currentItemSelected,

                    onChanged: (String newValueSelected){
                    //Your code to execute, when a menu item is selected from dropdown
                     _onDropDownItemSelected(newValueSelected);
                  },
                ))
              ],
            )),

            Padding(
              //add the padding
                padding: EdgeInsets.only(top: _minimumPadding, bottom: _minimumPadding),
                child:Row(children: <Widget>[
              Expanded(
                child: RaisedButton(
                  color: Theme.of(context).accentColor,
                  textColor: Theme.of(context).primaryColorDark,
                  child: Text('Calculate',textScaleFactor: 1.5,),
                  onPressed: (){
                    setState(() {
                      //if the user input is correct the only calculate the total returns
                      if ( _formKey.currentState.validate()) {
                        this.displayResult = _calculateTotalReturns();
                      }
                    });

                  },
                ),

              ),

              Expanded(
                child: RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  textColor: Theme.of(context).primaryColorLight,
                  child: Text('Reset',textScaleFactor: 1.5,),
                  onPressed: (){
                    setState(() {
                      _reset();
                    });

                  },
                ),

              ),

            ],)),

            Padding(
              padding: EdgeInsets.all(_minimumPadding * 2),
              child: Text(this.displayResult, style: textStyle,),
            )
          ])
        ),

        )
      );

  }
 Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/flight.png');
    Image image = Image(image: assetImage, width: 125.0, height: 125.0,);

    //wrap the image in a container and return it
    //to center it try to add margin
    return Container  (child: image,margin: EdgeInsets.all(_minimumPadding*10),);

 }
 void _onDropDownItemSelected(String newValueSelected){
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
 }
 String _calculateTotalReturns (){
    //first task is extract values from the textfields by using the controller
   double principal = double.parse((principalController.text));
   double roi = double.parse(roiController.text);
   double term = double.parse(termController.text);

   //formula for simple interest formula
   double totalAmountPayable = principal + (principal* roi * term) / 100;

   //return a result that will dispaly a result to the user
   String result = 'After $term years, your investment will be worth $totalAmountPayable $_currentItemSelected';

   //return the string
   return result;
 }
 void _reset(){
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentItemSelected = _currencies[0];
 }
}