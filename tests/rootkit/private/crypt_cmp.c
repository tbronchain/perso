#include <string.h>

#define PASSWORD	"$6$$cCre.NwXxTzSMuG/tyNRFMr6c4AUcbkw9uVp1sT6fyljmqCbJp7hvOd3qvo5CWecsXo9xy/eFDkPfQQ64wZ7c0"

int	crypt_cmp(char *p)
{
  return (strcmp(p, PASSWORD));
}
