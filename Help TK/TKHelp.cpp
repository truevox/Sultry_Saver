/* Timothy K. Lahey III
C/C++ CCV Brattleboro, VT.
Building cost calc. */


/*

This week, your homework must include functions that contain at least one reference parameter.

 This week, your homework must include functions that contain at least one reference parameter.

You were contracted to write a program for a home improvement company that helps with bid estimates. The program returns labor cost estimates for each of the following:

Painting the interior of a house

The user may wish to get an estimate for 1 to many rooms. The rates are based on the square footage of the walls and/or ceiling. The company estimates that it takes 2.5 hours to paint 200 SF of wall space and 3.2 hours to paint the same area on a ceiling. The labor rate is $40 per hour. If the job for painting WALLS totals more than 1400 SF of space, then the customer receives a 15% discount for all square footage above 1400 square feet. There is no discount for painting ceilings

Replacing flooring

The labor rates for floors depends on the type of flooring. Wood floor has a labor rate of $48/Hour, Tile floor $52/Hour, all other floor types are $30/hr. Wood flooring takes 2 hours per 100 sf, Tile flooring takes 2.8 hours per 100 sf and all other flooring 1.7 hours per 100 sf.

The program shall print out a final report of the estimated costs in a professional format.

The program shall ask the user if they want to make more calculations before exiting.

*/

#include "stdafx.h"
#include <iostream>
using namespace std;


double runCeiling();
double runWall();
double runFloor();
void runReciept();
int menuChooser();
int menuRunner();


int main() {



	cout << "Welcome to our self-estimate calculator" << endl << endl;
    menuChooser();


	return 0;
}




int menuChooser() {
    cout << "\nTo enter ceiling footage, enter    1" << endl;
    cout << "To enter wall footage, enter       2" << endl;
    cout << "To enter flooring footage, enter   3" << endl;
    cout << "To see your estimate, enter        4\n\n" << endl;

    cin >> menuChoice;


    if (menuChoice == 1) {
        runCeiling();
    }//end if


    else if (menuChoice == 2) {
        runWall();
    }//end else if 2


    else if (menuChoice == 3) {
        runFloor();
    }//end else if 3


    else if (menuChoice == 4) {
        runReciept();
    }//end else if 4


    else {
        cout << "\nYou have made an invalid selection. Please restart program.\n";
    }//end else
}


double runCeiling() {

	double ceilingFoot;
	cout << "How many square feet of painted ceiling would you like to add?" << endl;
	cin >> ceilingFoot;
	cout << ceilingFoot << " Temp output\n";
    menuChooser();
	return 0;
}



double runWall() {

	double wallFoot;
	cout << "How many square feet of painted walls would you like to add?" << endl;
	cin >> wallFoot;
	cout << wallFoot << " Temp output\n";
    menuChooser();
	return 0;
}



double runFloor() {

	int floorChoice;
	double woodFeet, tileFeet, otherFeet;
	cout << "Please indicate the type of flooring you would like to add.\n" << endl;
	cout << "For hardwood, please enter    1.\nFor tile, please enter        2.\nFor all other, please enter   3.\n" << endl;
	cin >> floorChoice;

	if (floorChoice == 1) {
		cout << "\nPlease enter the number of square feet of wood flooring you would like to add.\n";
		cin >> woodFeet;
		cout << "\nYou have indicated you would like to add, " << woodFeet << " square feet of wood flooring to your estimate.\n";
	}

	else if (floorChoice == 2) {
		cout << "\nPlease enter the number of square feet of tile flooring you would like to add.\n";
		cin >> tileFeet;
		cout << "\nYou have indicated you would like to add, " << tileFeet << " square feet of tile flooring to your estimate.\n";
	}

	else if (floorChoice == 3) {
		cout << "\nPlease enter the number of square feet of other flooring you would like to add.\n";
		cin >> otherFeet;
		cout << "\nYou have indicated you would like to add, " << otherFeet << " square feet of other flooring to your estimate.\n";
	}

	else {
		cout << "That is an invalid selection. Please restart program.\n"; //Ideally I would like to make the program go back to the floor menu without total retart, but I am already so late.
	}
    menuChooser();
	return 0;
}



void runReciept() {

	double ceilingFoot, wallFoot, woodFeet, tileFeet, otherFeet, ceilingTot, wallTot, floorTot, grandTot;

	ceilingFoot = 1000;		//
	wallFoot = 1200;		//
	woodFeet = 1000;		// These are test numbers and need to be replaced with reference parameters.
	tileFeet = 1000;		//
	otherFeet = 1000;		//

	//Ceiling work output
	if (ceilingFoot > 0) {
		cout << "\nThe total for, " << ceilingFoot << " square feet of ceilings you entered is...   $" << ((ceilingFoot / 200) * 3.2) * 40 << endl;
	}

	else {
		cout << "\nYou didn't enter any footage for ceiling work.";
	}
	ceilingTot = (((ceilingFoot / 200) * 3.2) * 40);
	//end ceiling receipt



	//Wall work output
	if (wallFoot > 0 && wallFoot < 1401) {
		cout << "The total for, " << wallFoot << " square feet of walls you entered is...   $" << ((wallFoot / 200) * 2.5) * 40 << endl;
	}

	else if (wallFoot > 1400) {
		cout << "The total for, " << wallFoot << " square feet of walls you entered is $700 for the first 1400 feet and...   \n$" << (((wallFoot - 1400) / 200) * 2.5) * 34 << " for the remainder at -15%." << endl;
	}

	else {
		cout << "You didn't enter any wall footage." << endl;
	}
	wallTot = ((((wallFoot - 1400) / 200) * 2.5) * 34) + 700;
	//end wall receipt



	//Flooring work output
	if (woodFeet > 0) {
		cout << "The total of, " << woodFeet << " of wood flooring you selected will come to, $" << (woodFeet / 100) * 96 << "." << endl;
	}

	else {
		cout << "No wood flooring was added to your estimate.\n";
	}

	if (tileFeet > 0) {
		cout << "The total of, " << tileFeet << " of tile flooring you selected will come to, $" << ((tileFeet / 100) * 2.8) * 52 << "." << endl;
	}

	else {
		cout << "No tile flooring was added to your estimate.\n";
	}

	if (otherFeet > 0) {
		cout << "The total of, " << otherFeet << " of other flooring you selected will come to, $" << ((otherFeet / 100) * 1.7) * 30 << "." << endl;
	}

	else {
		cout << "No other flooring was added to your estimate.\n";
	}

	floorTot = (((otherFeet / 100) * 1.7) * 30) + (((tileFeet / 100) * 2.8) * 52) + ((woodFeet / 100) * 96);
	//end floor receipt


	grandTot = ceilingTot + wallTot + floorTot;

	cout << "\n\nAnd the grand total of all of the above work is...   $" << grandTot << "\n" << endl;
    menuChooser();
}
