#include <iostream>
#include <string>
#include <cstdlib>
#include <vector>
#include <cmath>
#include <cstring>
#include <cstdint>

using namespace std;

string convertToBinaryString(unsigned int numArg) {
	string convNum = "";
	vector<int> base;
	for (int j=31; j>=0; j--) {
		base.push_back(pow(2, j));
	}
	for (int i=0; i<base.size(); i++) {
		if (numArg >= base[i]) {
			convNum = convNum + "1";
			numArg = numArg - base[i];
		} else {
			convNum = convNum + "0";
		}
	}
	return convNum;
}

string switchToTwosComp(string unS) {
	string lunS = unS;
	//cout << "Here" << endl;
	uint8_t f1 = 0;
	for (int i = (lunS.size() - 1); i>=0; i--) {
		if (i == 0) {
			lunS[i] = '1';
		} else if (f1 == 0 && lunS[i] == '1') { 
			f1 = 1; 
		} else if (f1 == 1) { 
			lunS[i] = (lunS[i] == '0') ? '1' : '0'; 
		} else { 
			continue; 
		}
	}
	return lunS;
}

int main(int argc, char* argv[]) {
	//cout << argv[1] << endl;
	if (strcmp(argv[1], "u") == 0) { // For making unsigned binary numbers (up to 32bits)
		unsigned int numArg;
		try { numArg = stoul(argv[2]); } catch(const out_of_range& e) { cerr << "Number larger than 32 bits" << endl; return 1; }
		cout << convertToBinaryString(numArg) << endl;
		
	} else if (strcmp(argv[1], "s") == 0) { // For making signed binary numbers (2's Compliment, up to 31bits)
		signed int numArg;
		try { numArg = stoi(argv[2]); } catch(const out_of_range& e) { cerr << "Max of 31 bits for signed int's" << endl; return 1; }
		string binRep = convertToBinaryString((numArg < 0) ? -1*numArg : numArg);
		string output = (numArg > 0) ? binRep : switchToTwosComp(binRep);
		cout << output << endl;

	} else if (strcmp(argv[1], "help") == 0) {
		cout << "USAGE:" << endl;
		cout << "Signed ints (2's comp)" << endl;
		cout << "\t ex: binary s -10 (up to 31 bit numbers)" << endl;
		cout << "Unsigned ints" << endl;
		cout << "\t ex: binary u 200 (up to 32 bit numbers)" << endl;
	} else { 
		cout << "Please specify (unsigned (u) or signed (s))" << endl; 
	}
	
	return 0;
}	
