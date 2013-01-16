#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <signal.h>
#include <sys/wait.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <netdb.h>

#define BUF_SIZE 1024

static int		findprotobyname(char *str)
{
  struct protoent	*p;

  if (!(p = getprotobyname(str)))
    return (0);
  return (p->p_proto);
}

int     send_data(char *str, int fd)
{
  int	max_len = strlen(str);
  int	len = 0;
  int	cur = 0;

  while (len < max_len)
    {
      cur = strlen(str + len) > BUF_SIZE ? BUF_SIZE : strlen(str + len);
      len += write(fd, str + len, cur);
    }
  return (len);
}

char    *recv_data(int fd)
{
  char	buf[BUF_SIZE + 1];
  int	rd = 0;
  int	i = 0;

  memset(buf, 0, BUF_SIZE + 1);
  rd = read(fd, buf, BUF_SIZE);
  while (i < rd)
    {
      if (buf[i] == '\n' || buf[i] == '\r')
	buf[i] = '\0';
      i++;
    }
  return (strdup(buf));
}

int     exec_command(char *cmd, int fd)
{
  char  buf[BUF_SIZE + 1];
  int   len;
  int   size;
  int   p[2];
  int	pid;

  pipe(p);
  if (!(pid = fork()))
    {
      close(p[0]);
      dup2(p[1], 1);
      system(cmd);
      exit(1);
    }
  else if (pid > 0)
    {
      close(p[1]);
      size = 0;
      memset(buf, 0, BUF_SIZE + 1);
      while ((len = read(p[0], buf, BUF_SIZE)) > 0)
	{
	  size += send_data(buf, fd);
	  memset(buf, 0, BUF_SIZE + 1);
	}
      close(p[0]);
    }
  return (size);
}

static int	loop(int fd)
{
  char		**r_line;
  char		*buf;
  int		j;

  send_data(" $ ", fd);
  while ((buf = recv_data(fd)))
    {
      exec_command(buf, fd);
      free(buf);
      send_data(" $ ", fd);
    }
  return (fd);
}

static int 		mult_client(int fd)
{
  struct sockaddr_in	client_sin;
  unsigned int		client_sin_len;
  int			fd_c;
  int			pid;

  while (1)
    {
      memset(&client_sin, 0, sizeof(client_sin));
      client_sin_len = sizeof(client_sin);
      fd_c = accept(fd, (struct sockaddr *)&client_sin, &client_sin_len);
      if (!(pid = fork()))
	return (loop(fd_c));
      close(fd_c);
    }
  return (0);
}

int			main(int ac, char **av)
{
  struct sockaddr_in	sin;
  int			fd;

  fd = socket(AF_INET, SOCK_STREAM, 0);
  sin.sin_family = AF_INET;
  sin.sin_port = htons(2342);
  sin.sin_addr.s_addr = htonl(INADDR_ANY);
  if (bind(fd, (struct sockaddr *)&sin, sizeof(sin)) < 0)
    {
      puts("bind error");
      exit(0);
    }
  listen(fd, 16);
  if ((fd = mult_client(fd)) > 0)
    close(fd);
  return (EXIT_SUCCESS);
}
