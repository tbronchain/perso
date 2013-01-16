#ifndef SERVER_H_
# define SERVER_H_

# ifdef WIN32
#  include <Windows.h>
# endif //!WIN32

# include <stdio.h>
# include <stdlib.h>
# include <errno.h>
# include <string.h>

# include "client.h"

# define CRLF		"\r\n"
# define PORT		1977
# define MAX_CLIENTS	100

//#include "client.h"

static void		init(void);
static void		end(void);
static void		app(void);
static int		init_connection(void);
static void		end_connection(int s);
static int		read_client(SOCKET s, char *buffer);
static void		write_client(SOCKET sock, const char *buffer);
static void		send_message_to_all_clients(Client *clients, Client client, int actual, const char *buffer, char from_server);
static void		remove_client(Client *clients, int to_remove, int *actual);
static void		clear_clients(Client *clients, int actual);

#endif //!SERVER_H_
