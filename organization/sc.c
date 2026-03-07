#include <stdio.h>
#include <sqlite3.h>
#include <stdlib.h>
#include <string.h>
// ***WORK IN PROGRESS*** - Store Command
// A program to store commonly used commands with arguements for future use
//
struct Str {
	char *value;
	int length;
	int capacity;
};

int doubleAllocation(struct Str *ptr) {
	// printf("%d\n", ptr->length);
	char *newPtr = malloc((ptr->length) * 2 * sizeof(char) + 1);
	for (int i = 0; i<ptr->length; i++) newPtr[i] = ptr->value[i];
	free(ptr->value);  // Stop Leaks
	ptr->value = newPtr;
	ptr->capacity = ptr->capacity * 2;
	return 0;
}
	
int loadStr(struct Str *str, char *given) {
	int ct = 0;
	while (given[ct] != '\0') {
		if ((str->capacity) == str->length) doubleAllocation(str);
		str->value[ct] = given[ct];
		str->length++;
		ct++;
	}
	ct++;
	str->value[ct] = '\0';  // add null terminator
	return 0;
}

int countArgs(struct Str *str) {
	int ct = 0;
	for (int i = 0; i < str->length; i++) {
		if (str->value[i] == '&') ++ct;
	}
	return ct;
}

int main(int argc, char *argv[]) {
	sqlite3 *db;
	if (sqlite3_open("/home/benon/dbs/commands.db", &db) != SQLITE_OK) {
		fprintf(stderr, "Cannot open database\n");
		return 1;
	}
	// execute sql
	char *sql = "CREATE TABLE IF NOT EXISTS COMMANDS(name varchar(30) PRIMARY KEY, Payload TEXT, num_args int DEFAULT 0);";
	if (sqlite3_exec(db, sql, 0, 0, 0) != SQLITE_OK) {
		fprintf(stderr, "SQL Error\n");
	}
	// add command
	if (argc < 2) {
		printf("No action given\n");
		return 1;
	}
	// printf("%s", argv[1]);
	if (strcmp(argv[1], "add") == 0) {
		char *payload = argv[2];
		char *name_given = argv[3];
		// setup up payload Str
		struct Str str;
		str.value = malloc(5 * sizeof(char)); // need extra for null at end
		str.length = 0;
		str.capacity = 4;
		loadStr(&str, payload);
		int args = countArgs(&str);
		// Set up name Str
		struct Str name;
		name.value = malloc(5 * sizeof(char));
		name.length = 0;
		name.capacity = 4;
		loadStr(&name, name_given);
		//SQL stuff
		sqlite3_stmt *stmt;
		const char *sql = "INSERT INTO Commands (name, payload, num_args) VALUES (?, ?, ?)";
		if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) == SQLITE_OK) {
			sqlite3_bind_text(stmt, 1, name.value, -1, SQLITE_TRANSIENT);
			sqlite3_bind_text(stmt, 2, str.value, -1, SQLITE_TRANSIENT);
			sqlite3_bind_int(stmt, 3, args);
			if (sqlite3_step(stmt) != SQLITE_DONE) fprintf(stderr, "Failed to save command: %s\n", sqlite3_errmsg(db));
			else fprintf(stdout, "Succesfully saved command: %s : %s\n", name.value, str.value);
			sqlite3_finalize(stmt);
		} else fprintf(stderr, "SQL Error: %s \n", sqlite3_errmsg(db));
		// Free at end of use
		free(name.value);
		free(str.value);
	} else if (strcmp(argv[1], "run") == 0) {
		char *command_name = argv[2];
		//SQL stuff
		sqlite3_stmt *stmt;
		if (sqlite3_prepare_v2(dv, sql, -1, &stmt, NULL) == SQLITE_OK) {
			
		}
	}
		
		
		
	
	sqlite3_close(db);
	return 0;
}
