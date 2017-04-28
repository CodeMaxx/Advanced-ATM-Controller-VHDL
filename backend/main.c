/*
 * Copyright (C) 2012-2014 Chris McClelland
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public licenses
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <errno.h>
#include <makestuff.h>
#include <libfpgalink.h>
#include <libbuffer.h>
#include <liberror.h>
#include <libdump.h>
#include <argtable2.h>
#include <readline/readline.h>
#include <readline/history.h>
#ifdef WIN32
#include <Windows.h>
#else
#include <sys/time.h>
#endif
#include <unistd.h>
#include <limits.h>

bool sigIsRaised(void);
void sigRegisterHandler(void);

// static const char *const errMessages[] = {
// 	NULL,
// 	NULL,
// 	"Unparseable hex number",
// 	"Channel out of range",
// 	"Conduit out of range",
// 	"Illegal character",
// 	"Unterminated string",
// 	"No memory",
// 	"Empty string",
// 	"Odd number of digits",
// 	"Cannot load file",
// 	"Cannot save file",
// 	"Bad arguments"
// };

typedef enum {
	FLP_SUCCESS,
	FLP_LIBERR,
	FLP_BAD_HEX,
	FLP_CHAN_RANGE,
	FLP_CONDUIT_RANGE,
	FLP_ILL_CHAR,
	FLP_UNTERM_STRING,
	FLP_NO_MEMORY,
	FLP_EMPTY_STRING,
	FLP_ODD_DIGITS,
	FLP_CANNOT_LOAD,
	FLP_CANNOT_SAVE,
	FLP_ARGS
} ReturnCode;

////////////////////////////////////////////////////////////////////////////////////////////////

//Citation: http://stackoverflow.com/questions/20212714/reading-a-csv-file-into-struct-array

#define MAX_STR_LEN 256
#define MAX_USERS 65535 //set to int max

struct User{
	int ID;
	int PIN;
	int isadmin;
	int balance;
};

struct User Users[MAX_USERS];

int readUsersFromFile(void);
void printUserList(int numberOfUsers);

int readUsersFromFile(void){
	/* FileStream for the Library File */
	FILE *f;

	/* allocation of the buffer for every line in the File */
	char *buffer = malloc(MAX_STR_LEN);
	char *tmp;

	/* if the space could not be allocated, return an error */
	if (buffer == NULL) {
		printf ("No memory\n");
		return 0;
	}

	if ((f = fopen( "input.csv", "r" )) == NULL ){ //Reading a file
		printf( "File could not be opened.\n" );
		return 0;
	}

	int i = 0;
	while (fgets(buffer, 255, f) != NULL){
		if ((strlen(buffer)>0) && (buffer[strlen (buffer) - 1] == '\n'))
			buffer[strlen (buffer) - 1] = '\0';
		if(i==0){
			i++;
			continue;
		}
		tmp = strtok(buffer, ",");
		Users[i-1].ID = atoi(tmp);

		tmp = strtok(NULL, ",");
		Users[i-1].PIN = atoi(tmp);

		tmp = strtok(NULL, ",");
		Users[i-1].isadmin = atoi(tmp);

		tmp = strtok(NULL, ",");
		Users[i-1].balance = atoi(tmp);

		// printf("index i= %i  ID: %i, %i, %i, %i \n", i, Users[i-1].ID , Users[i-1].PIN, Users[i-1].isadmin , Users[i-1].balance);
		i++;
	}
	free(buffer);
	fclose(f);
	return i-1;
}

// void printUserList(int numberOfUsers){
// 	int i;
// 	printf("%d\n", numberOfUsers);
// 	for (i = 1; i <= numberOfUsers; i++)
// 		printf("index i= %i  ID: %i, %i, %i, %i \n",i, Users[i].ID , Users[i].PIN, Users[i].isadmin , Users[i].balance);
// }

void encrypt (uint8* realData) {
	printf("Encrypting\n");
	uint32_t k0=0xff0f7457, k1=0x43fd99f7, k2=0x75f8c48f, k3=0x2927c18c;   /* cache key */
	uint32_t v[2];
	v[0] = 0;
	v[1] = 0;
	for(int i = 0; i<4; i++){
		v[0] = v[0] | realData[i] << 8*(3-i);
	}
	for(int i = 4; i<8; i++){
		v[1] = v[1] | realData[i] << 8*(7-i);
	}

	uint32_t v0=v[0], v1=v[1], sum=0, i;           /* set up */
	uint32_t delta=0x9e3779b9;                     /* a key schedule constant */
	for (i=0; i < 32; i++) {                       /* basic cycle start */
		sum += delta;
		v0 += ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
		v1 += ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
	}                                              /* end cycle */
	v[0]=v0; v[1]=v1;
	realData[3] = (v0 & 0x000000ff);
	realData[2] = (v0 & 0x0000ff00) >> 8;
	realData[1] = (v0 & 0x00ff0000) >> 16;
	realData[0] = (v0 & 0xff000000) >> 24;

	realData[7] = (v1 & 0x000000ff);
	realData[6] = (v1 & 0x0000ff00) >> 8;
	realData[5] = (v1 & 0x00ff0000) >> 16;
	realData[4] = (v1 & 0xff000000) >> 24;

	printf("Encryption done\n");

}

uint16 hashPIN(uint16 PIN){
	return (PIN << 11) | (PIN >> 5);
}

bool matchPIN(uint16 ID, uint16 PIN, bool* isAdmin,int* cash,int* index, int numberOfUsers){
	for(int i = 0; i<numberOfUsers; i++){
		if(Users[i].ID == ID){
			if(Users[i].PIN == PIN){
				*isAdmin = Users[i].isadmin;
				*cash = Users[i].balance;
				*index = i;
				return true;
			}
			else return false;
		}
	}
	return false;
}

void updateCSVfile(int numberOfUsers){
	FILE *fout;
	fout = fopen ("input.csv", "w");
	if(fout != NULL){
		fprintf(fout,"\"User ID (decimal)\",\"PIN Hash (decimal)\",\"Admin\",\"Balance (decimal)\"\n");
		for(int i = 0; i<numberOfUsers; i++){
			fprintf(fout,"%i,%i,%i,%i\n",Users[i].ID , Users[i].PIN, Users[i].isadmin , Users[i].balance);
		}
		fclose(fout);
	}
}

void updateBalance(int index, int cashReqd, int numberOfUsers){
	printf("Updating Balance\n");
	Users[index].balance -= cashReqd;
	updateCSVfile(numberOfUsers);
}

void decrypt (uint8* data, uint8* realData) {\



  // uint32_t v0=v[0], v1=v[1], sum=0xC6EF3720, i;  /* set up */
  //   uint32_t delta=0x9e3779b9;                     /* a key schedule constant */
  //   uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];   /* cache key */
  //   for (i=0; i<32; i++) {                         /* basic cycle start */
  //       v1 -= ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
  //       v0 -= ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
  //       sum -= delta;
  //   }                                              /* end cycle */
  //   v[0]=v0; v[1]=v1;


	printf("Decrypting\n");

	sleep(1);
	uint32_t k0=0xff0f7457, k1=0x43fd99f7, k2=0x75f8c48f, k3=0x2927c18c;   /* cache key */
	uint32_t v[2];
	v[0] = 0;
	v[1] = 0;
	for(int i = 0; i<4; i++){
		v[0] = v[0] | data[i] << 8*(3-i);
	}
	for(int i = 4; i<8; i++){
		v[1] = v[1] | data[i] << 8*(7-i);
	}
	uint32_t v0=v[0], v1=v[1], sum=0xC6EF3720, i;  /* set up */
	uint32_t delta=0x9e3779b9;                     /* a key schedule constant */
	for (i=0; i<32; i++) {                         /* basic cycle start */
		v1 -= ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
		v0 -= ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
		sum -= delta;
	}                                              /* end cycle */
	v[0]=v0; v[1]=v1;

	realData[3] = (v0 & 0x000000ff);
	realData[2] = (v0 & 0x0000ff00) >> 8;
	realData[1] = (v0 & 0x00ff0000) >> 16;
	realData[0] = (v0 & 0xff000000) >> 24;

	realData[7] = (v1 & 0x000000ff);
	realData[6] = (v1 & 0x0000ff00) >> 8;
	realData[5] = (v1 & 0x00ff0000) >> 16;
	realData[4] = (v1 & 0xff000000) >> 24;
	printf("Decrypting done\n");
}

////////////////////////////////////////////////////////////////////////////////////////////////

int main(int argc, char* argv[]) {

//////////////////////////Advanced///////////////////////
	if(argc < 2)
	{
		printf("Usage: %s [Bank ID]\n", argv[0]);
		return 0;
	}
	else if(atoi(argv[1]) > 31)
	{
		printf("Bank ID must be between 0-31(both inclusive)\n");
		return 0;
	}

	uint8 BankID = atoi(argv[1]);

//////////////////////////Advanced///////////////////////


	ReturnCode retVal = FLP_SUCCESS;
	struct FLContext *handle = NULL;
	FLStatus fStatus;
	const char *error = NULL;
	const char *ivp = NULL;
	const char *vp = NULL;
	bool isCommCapable;
	const char *line = NULL;
	uint8 conduit = 0x01;

	fStatus = flInitialise(0, &error);
	CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);

	vp = "1443:0007";

	printf("Attempting to open connection to FPGALink device %s...\n", vp);
	fStatus = flOpen(vp, &handle, NULL);
	if ( fStatus ) {
		// if ( ivpOpt->count ) {
			int count = 60;
			uint8 flag;
			ivp = "1443:0007";
			// ivp = ivpOpt->sval[0];
			printf("Loading firmware into %s...\n", ivp);
			// if ( fwOpt->count ) {
			// 	fStatus = flLoadCustomFirmware(ivp, fwOpt->sval[0], &error);
			// } else {
				fStatus = flLoadStandardFirmware(ivp, vp, &error);
			// }
			CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);

			printf("Awaiting renumeration");
			flSleep(1000);
			do {
				printf(".");
				fflush(stdout);
				fStatus = flIsDeviceAvailable(vp, &flag, &error);
				CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
				flSleep(250);
				count--;
			} while ( !flag && count );
			printf("\n");
			if ( !flag ) {
				fprintf(stderr, "FPGALink device did not renumerate properly as %s\n", vp);
				FAIL(FLP_LIBERR, cleanup);
			}

			printf("Attempting to open connection to FPGLink device %s again...\n", vp);
			fStatus = flOpen(vp, &handle, &error);
			CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
		// } else {
		// 	fprintf(stderr, "Could not open FPGALink device at %s and no initial VID:PID was supplied\n", vp);
		// 	FAIL(FLP_ARGS, cleanup);
		// }
	}

	printf(
		"Connected to FPGALink device %s (firmwareID: 0x%04X, firmwareVersion: 0x%08X)\n",
		vp, flGetFirmwareID(handle), flGetFirmwareVersion(handle)
	);

	// // if ( eepromOpt->count ) {
	// 	// if ( !strcmp("std", eepromOpt->sval[0]) ) {
	// 		printf("Writing the standard FPGALink firmware to the FX2's EEPROM...\n");
	// 		fStatus = flFlashStandardFirmware(handle, vp, &error);
		// } else {
			// printf("Writing custom FPGALink firmware from %s to the FX2's EEPROM...\n", eepromOpt->sval[0]);
			// fStatus = flFlashCustomFirmware(handle, eepromOpt->sval[0], &error);
		// }
		// CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
	// }

	// isNeroCapable = flIsNeroCapable(handle);
	isCommCapable = flIsCommCapable(handle, conduit);


	// if ( progOpt->count ) {
	// printf("Programming device...\n");
	// if ( isNeroCapable ) {
	// 	fStatus = flSelectConduit(handle, 0x00, &error);
	// 	CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
	// 	fStatus = flProgram(handle, "J:D0D2D3D4:fpga.xsvf", NULL, &error);
	// 	CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
	// } else {
	// 	fprintf(stderr, "Program operation requested but device at %s does not support NeroProg\n", vp);
	// 	FAIL(FLP_ARGS, cleanup);
	// }
	// }


// --------------------------------------------------------------------------------
	int numberOfUsers = 0;
	numberOfUsers = readUsersFromFile();
	if(!numberOfUsers)
		printf("Empty file!\n");
	printf("Reading csv done\n");
	// printUserList(numberOfUsers);
	if ( isCommCapable ) {
		uint8 isRunning;
		fStatus = flSelectConduit(handle, conduit, &error);
		CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
		fStatus = flIsFPGARunning(handle, &isRunning, &error);
		CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
		if ( isRunning ) {
			while(1) {
				sleep(1);
				uint8 buffer, message;
				fStatus = flReadChannel(handle, (uint8) 0, 1, &buffer, &error);
				CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
				if((buffer==0x01) | (buffer==0x02)){
					sleep(1);
					uint8 buffer2;
					fStatus = flReadChannel(handle, (uint8) 0, 1, &buffer2, &error);
					CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
					if(buffer==buffer2){
						sleep(1);
						uint8 buffer3;
						fStatus = flReadChannel(handle, (uint8) 0, 1, &buffer3, &error);
						CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
						if(buffer==buffer3){
							printf("communication starting\n");


////////////////////////////////Advanced///////////////////////////////////

							uint8 restrictions[4];
							restrictions[0] = INT8_MAX; // Restriction on 2000 notes
							restrictions[1] = INT8_MAX; // Restriction on 1000 notes
							restrictions[2] = INT8_MAX; // Restriction on 500 notes
							restrictions[3] = INT8_MAX; // Restriction on 100 notes
							uint res_total = UINT_MAX; // TODO - Will have to change this in VHDL.
							printf("Sending Restriction Info...\n");
							for(int i = 20; i < 24; i++)
							{
								fStatus = flWriteChannel(handle, (uint8) i, 1, &restrictions[i-20], &error);
								CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
							}

							uint8 restrict_total[4] = {res_total >> 24, res_total >> 16, res_total >> 8, res_total};

							for(int i = 24, i < 28; i++)
							{
								fStatus = flWriteChannel(handle, (uint8) i, 1, &restrict_total[i-25], &error);
								CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
							}
							printf("Restriction Info Sent!\n");

////////////////////////////////Advanced///////////////////////////////////


							uint8 data[8];
							for(int i = 0; i < 8; i++){
								fStatus = flReadChannel(handle, (uint8) i+1, 1, &data[i], &error);
								fStatus = flReadChannel(handle, (uint8) i+1, 1, &data[i], &error);
								CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
							}
							uint8 realData[8];
							decrypt(data, realData); //change decrypt function
							uint16 ID = realData[0] << 8 | realData[1];
							if(ID >> )
							uint16 PIN = realData[2] << 8 | realData[3];
							PIN = hashPIN(PIN);

							uint8 check_bank = (PIN >> 11);

							if(check_bank != BankID)
							{
								printf("Something wrong with the front end. This user is not of this bank.\n");
								return 0;
							}

							bool isAdmin;
							int cash, index;
							bool valid = matchPIN(ID, PIN, &isAdmin, &cash, &index, numberOfUsers);
							if(!valid){
								printf("Invalid pin or id\n");
								message = 0x04;
								fStatus = flWriteChannel(handle, (uint8) 9, 1, &message, &error);
								CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
							}else{
								printf("Valid pin and id\n");
								//// Advanced
								uint cashReqd = realData[4]*pow(2,24) + realData[5]*pow(2,16) + realData[6]*pow(2,8) + realData[7];
								// Calculate amount of cash

								for(int i = 0; i < 4; i++)	realData[i] = 0;
								
								if(!isAdmin){
									if(cashReqd<=cash and cashReqd <= res_total){
										realData[3] = 0x06;
										encrypt(realData);
										for(int i = 0; i < 8; i++){
											fStatus = flWriteChannel(handle, (uint8) i+10, 1, &realData[i], &error);
											CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
										}
										message = 0x01;
										fStatus = flWriteChannel(handle, (uint8) 9, 1, &message, &error);
										CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
										updateBalance(index, cashReqd,numberOfUsers);
										printf("Sufficient balance\n");
									}
									else{
										realData[3] = 0x02;
										encrypt(realData);
										for(int i = 0; i < 8; i++){
											message = 0x00;
											fStatus = flWriteChannel(handle, (uint8) i+10, 1, &message, &error);
											CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
										}
										message = 0x02;
										fStatus = flWriteChannel(handle, (uint8) 9, 1, &message, &error);
										CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
									}
								}
								else{
									realData[3] = 0x01;
									encrypt(realData);
									for(int i = 0; i < 8; i++){
										fStatus = flWriteChannel(handle, (uint8) i+10, 1, &realData[i], &error);
										CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
									}
									message = 0x03;
									fStatus = flWriteChannel(handle, (uint8) 9, 1, &message, &error);
									CHECK_STATUS(fStatus, FLP_LIBERR, cleanup);
									if(buffer==0x01)
										updateBalance(index, cashReqd,numberOfUsers);
								}
							}
						}
					}
				}
			}

		}
		else {
			fprintf(stderr, "The FPGALink device at %s is not ready to talk - did you forget --program?\n", vp);
			FAIL(FLP_ARGS, cleanup);
		}
	}
	else {
		fprintf(stderr, "Action requested but device at %s does not support CommFPGA\n", vp);
		FAIL(FLP_ARGS, cleanup);

	}

// --------------------------------------------------------------------------------

cleanup:
	free((void*)line);
	flClose(handle);
	if ( error ) {
		fprintf(stderr, "%s\n", error);
		flFreeError(error);
	}
	return retVal;
uint8
