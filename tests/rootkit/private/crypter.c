/*
** crypter.c for rsh by Thibault BRONCHAIN
*/

#define _XOPEN_SOURCE
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int	main(int ac, char **av)
{
  char	*s;
  char	*p;

  if (ac != 2)
    {
      fputs("Syntax ERROR\n", stderr);
      return (EXIT_FAILURE);
    }
  s = "$6$";
  if ((p = crypt(av[1], s)) == NULL)
    {
      fputs("Fatal ERROR\n", stderr);
      return (EXIT_FAILURE);
    }
  puts(av[1]);
  puts(p);
  return (EXIT_SUCCESS);
}
