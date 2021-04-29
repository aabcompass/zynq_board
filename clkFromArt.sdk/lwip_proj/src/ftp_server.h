/*
 * ftp_server.h
 *
 *  Created on: Jun 26, 2018
 *      Author: alx
 */



#define MAX_FILES			1000	 /*  */
#define MAX_FILENAME_LEN	51

typedef enum {file_regular, file_scidata} File_types;

typedef struct
{
	uint8_t is_presented;
	uint8_t is_closed;
	char filename[MAX_FILENAME_LEN];
	File_types file_type;
	uint32_t length;
	uint32_t unix_time;
	uint32_t mmg_file_descriptor;
	char* link;
} FileRecord;


void PrintFS();
void FileSystemInit();
int CreateFile(char* filename, char* pData, int size, uint32_t unix_time, File_types file_type);
int CreateSciFile(char* pData, int size, uint32_t unix_time, int data_type, uint32_t mmg_file_descriptor);
void CloseFile(int descriptor, uint32_t file_size) ;
void SendDir();
int RemoveAllSciDataFilesFromFTP();
void CreateTestFiles();



#define MAX_SIZE_TCP_PACKET 1460 /*bytes*/




#ifndef SRC_FTP_SERVER_H_
#define SRC_FTP_SERVER_H_



#endif /* SRC_FTP_SERVER_H_ */
