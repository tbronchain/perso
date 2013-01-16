
#include "server.h"
#include "client.h"

static int	initSock(void)
{
  SOCKET	sock = socket(AF_INET, SOCK_STREAM, 0);
  SOCKADDR_IN	sin = {0};

  if (sock == INVALID_SOCKET)
    {
      perror("socket()");
      exit(errno);
    }

  sin.sin_addr.s_addr = htonl(INADDR_ANY);
  sin.sin_port = htons(PORT);
  sin.sin_family = AF_INET;

  if (bind(sock, (SOCKADDR*)&sin, sizeof sin) == SOCKET_ERROR)
    {
      perror("bind()");
      exit(errno);
    }

  if (listen(sock, MAX_CLIENTS) == SOCKET_ERROR)
    {
      perror("listen()");
      exit(errno);
    }

  return sock;
}

static void	init(void)
{
  WSADATA wsa;
  if (WSAStartup(MAKEWORD(2, 2), &wsa) < 0)
    {
      fprintf(stderr, "%s\n", "WSASTARTUP failed");
    }
}

static void	end(void)
{
  WSACleanup();
}

static void	app(void)
{
  SOCKET sock = initSock();

  char buffer[BUF_SIZE];
  int actual = 0;
  int max = sock;
  Client clients[MAX_CLIENTS];

  fd_set rdfs;

  while (1)
    {
      int i = 0;
      FD_ZERO(&rdfs);
      //FD_SET(STDIN_FILENO, &rdfs);
      FD_SET(sock, &rdfs);

      for (i = 0; i < actual; i++)
	{
	  FD_SET(clients[i].sock, &rdfs);
	}

      printf("max = %d, socket = %d\n", max, sock);
      if (select(max + 1, &rdfs, NULL, NULL, NULL) == -1)
	{
	  perror("select()");
	  exit(errno);
	}

      if (FD_ISSET(STDIN_FILENO, &rdfs))
	{
	  break;
	}
      else if (FD_ISSET(sock, &rdfs))
	{
	  SOCKADDR_IN csin = { 0 };
	  size_t sinsize = sizeof csin;
	  int csock = accept(sock, (SOCKADDR *)&csin, &sinsize);
	  if (csock == SOCKET_ERROR)
	    {
	      perror("accept()");
	      continue;
	    }

	  if (read_client(csock, buffer) == -1)
	    {
	      continue;
	    }

	  max = csock > max ? csock : max;
	  FD_SET(csock, &rdfs);

	  Client c = { csock };
	  strncpy(c.name, buffer, BUF_SIZE - 1);
	  clients[actual] = c;
	  actual++;
	}
      else
	{
	  int i = 0;
	  for (i = 0; i < actual; i++)
	    {
	      /* a client is talking */
	      if(FD_ISSET(clients[i].sock, &rdfs))
		{
		  Client client = clients[i];
		  int c = read_client(clients[i].sock, buffer);
		  /* client disconnected */
		  if(c == 0)
		    {
		      closesocket(clients[i].sock);
		      remove_client(clients, i, &actual);
		      strncpy(buffer, client.name, BUF_SIZE - 1);
		      strncat(buffer, " disconnected !", BUF_SIZE - strlen(buffer) - 1);
		      send_message_to_all_clients(clients, client, actual, buffer, 1);
		    }
		  else
		    {
		      send_message_to_all_clients(clients, client, actual, buffer, 0);
		    }
		  break;
		}
	    }
	}
    }

  clear_clients(clients, actual);
  end_connection(sock);
}

static void clear_clients(Client *clients, int actual)
{
  int i = 0;
  for(i = 0; i < actual; i++)
    {
      closesocket(clients[i].sock);
    }
}

static void remove_client(Client *clients, int to_remove, int *actual)
{
  /* we remove the client in the array */
  memmove(clients + to_remove, clients + to_remove + 1, (*actual - to_remove - 1) * sizeof(Client));
  /* number client - 1 */
  (*actual)--;
}

static void send_message_to_all_clients(Client *clients, Client sender, int actual, const char *buffer, char from_server)
{
  int i = 0;
  char message[BUF_SIZE];
  message[0] = 0;
  for(i = 0; i < actual; i++)
    {
      if(sender.sock != clients[i].sock)
	{
	  if(from_server == 0)
	    {
	      strncpy(message, sender.name, BUF_SIZE - 1);
	      strncat(message, " : ", sizeof message - strlen(message) - 1);
	    }
	  strncat(message, buffer, sizeof message - strlen(message) - 1);
	  write_client(clients[i].sock, message);
	}
    }
}


static void end_connection(int sock)
{
  closesocket(sock);
}

static int read_client(SOCKET sock, char *buffer)
{
  int n = 0;

  if ((n = recv(sock, buffer, BUF_SIZE - 1, 0)) < 0)
    {
      perror("recv()");
      n = 0;
    }

  buffer[n] = 0;

  return n;
}

static void write_client(SOCKET sock, const char *buffer)
{
  if(send(sock, buffer, strlen(buffer), 0) < 0)
    {
      perror("send()");
      exit(errno);
    }
}

int		main(int ac, char** av)
{
  init();
  app();
  end();

  return EXIT_SUCCESS;
}
