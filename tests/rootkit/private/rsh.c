/*
** rsh.c for rsh by Thibault BRONCHAIN
*/

#define _XOPEN_SOURCE
#include <sys/ioctl.h>
#include <sys/termios.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <strings.h>
#include <string.h>
#include "rsh.h"

int			my_strcmp(char *s1, char *s2)
{
  int			i;

  for (i = 0 ; s1[i] ; i++)
    if (s1[i] != s2[i])
      return (-1);
  return (0);
}

int			ld_check(void)
{
  extern char**		environ;
  int			i;

  for (i = 0 ; environ[i] ; i++)
    if (!my_strcmp("LD_PRELOAD", environ[i]))
      return (-1);
    else if (!my_strcmp("LD_LIBRARY_PATH", environ[i]))
      return (-1);
  return (0);
}

int			non_canonical_mode(struct termios *oldline)
{
  struct termios	line;

  if (tcgetattr(0, oldline) < 0)
    return (-1);
  bcopy(oldline, &line, sizeof(line));
  line.c_lflag &= ~ECHO;
  if (tcsetattr(0, TCSANOW, &line) < 0)
    return (-1);
  return (0);
}

int			restore_mode(struct termios *oldline)
{
  if (tcsetattr(0, TCSANOW, oldline) < 0)
    return (-1);
  return (0);
}

int			be_root(const char* shell)
{
  if (setuid(0))
    return (-1);
  else if (setgid(0))
    return (-1);
  else if (system(shell) < 0)
    return (-1);
  return (0);
}

int			get_pass(void)
{
  struct termios	oldline;
  char			buf[BUF_SIZE + 1];
  int			len;
  char			*p;
  char			*c;

  fputs("Password: ", stderr);
  if (non_canonical_mode(&oldline) < 0)
    return (-1);
  else if ((len = read(0, buf, BUF_SIZE)) <= 0)
    {
      restore_mode(&oldline);
      return (-1);
    }
  else if (restore_mode(&oldline) < 0)
    return (-1);
  puts("");
  buf[len - 1] = '\0';
  c = "$6$";
  if (ld_check())
    return (-2);
  else if ((p = crypt(buf, c)) == NULL)
    return (-1);
  else if (crypt_cmp(p))
    return (1);
  else if (be_root(SHELL))
    return (-1);
  return (0);
}

int		main(void)
{
  int		res;

  if (ld_check())
    {
      fputs("Permission DENIED\n", stderr);
      return (EXIT_FAILURE);
    }
  else if ((res = get_pass()) == -2)
    {
      fputs("Permission DENIED\n", stderr);
      return (EXIT_FAILURE);
    }
  else if (res < 0)
    {
      fputs("FATAL ERROR\n", stderr);
      return (EXIT_FAILURE);
    }
  else if (res > 0)
    {
      fputs("Permission DENIED\n", stderr);
      return (EXIT_FAILURE);
    }
  return (EXIT_SUCCESS);
}
