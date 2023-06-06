#include <stdio.h>
#include <string.h>
#include <argon2.h>
#include <erl_nif.h>

void hash_password(const char* password, const char* salt, unsigned char* hash, size_t hashlen) {
  const uint32_t t_cost = 3;
  const uint32_t m_cost = 1 << 16; // 64 MiB
  const size_t saltlen = strlen(salt);
  const size_t passwordlen = strlen(password);

  argon2_context context = {
    .out = hash,
    .outlen = hashlen,
    .pwd = (uint8_t*)password,
    .pwdlen = passwordlen,
    .salt = (uint8_t*)salt,
    .saltlen = saltlen,
    .secret = NULL,
    .secretlen = 0,
    .ad = NULL,
    .adlen = 0,
    .t_cost = t_cost,
    .m_cost = m_cost,
    .lanes = 1,
    .threads = 1,
    .allocate_cbk = NULL,
    .free_cbk = NULL,
    .flags = ARGON2_DEFAULT_FLAGS
  };

  int result = argon2i_ctx(&context);
  if (result != ARGON2_OK) {
    fprintf(stderr, "Error occurred during password hashing: %s\n", argon2_error_message(result));
  }
}

static ERL_NIF_TERM hash_password_nif(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[]) {
  ErlNifBinary password_bin, salt_bin;

  if (!enif_inspect_binary(env, argv[0], &password_bin))
    return enif_make_badarg(env);

  if (!enif_inspect_binary(env, argv[1], &salt_bin))
    return enif_make_badarg(env);

  size_t hashlen = ARGON2_MAX_OUTLEN;
  unsigned char* hash = enif_alloc(hashlen);

  hash_password((const char*)password_bin.data, (const char*)salt_bin.data, hash, hashlen);

  ErlNifBinary hash_bin;
  enif_alloc_binary(hashlen, &hash_bin);
  memcpy(hash_bin.data, hash, hashlen);

  ERL_NIF_TERM hash_term = enif_make_binary(env, &hash_bin);

  enif_free(hash);

  return hash_term;
}

static ErlNifFunc nif_funcs[] = {
  {"hash_password_nif", 2, hash_password_nif, ERL_NIF_DIRTY_JOB_CPU_BOUND}
};

ERL_NIF_INIT(Elixir.PasswordHash.Nif, nif_funcs, NULL, NULL, NULL, NULL)

