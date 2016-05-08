/**
 * The purpose of this file is to simply replace original OpenSSL's "UI" interface implementation.
 * We don't need UI at all. This change is fixing some linking problems at few architectures.
 */

#include <openssl/e_os2.h>
#include "ui_locl.h"
#include "cryptlib.h"

static int dummy_open_close(UI *ui)
{
	/* simulates correct opening */
	return 1;
}

static int dummy_read_write_string(UI *ui, UI_STRING *uis)
{
	/* read or write is not possible */
	return 0;
}

static UI_METHOD ui_dummy =
{
	"Dummy UI",
	dummy_open_close,
	dummy_read_write_string,
	NULL,
	dummy_read_write_string,
	dummy_open_close,
	NULL
};

UI_METHOD *UI_OpenSSL(void)
{
	return &ui_dummy;
}
