#ifndef CLIENT_H_
# define CLIENT_H_

# ifndef SOCKET
#  define SOCKET int
# endif //!SOCKET

# define BUF_SIZE	1024

typedef		struct
{
  SOCKET	sock;
  //  char		toWrite[BUFSIZE];
  char		name[BUF_SIZE];
}		Client;

#endif //!CLIENT_H_
