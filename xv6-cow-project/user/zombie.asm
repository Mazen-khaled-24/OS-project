
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	286080e7          	jalr	646(ra) # 28e <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	280080e7          	jalr	640(ra) # 296 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	306080e7          	jalr	774(ra) # 326 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e422                	sd	s0,8(sp)
  2e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  30:	87aa                	mv	a5,a0
  32:	0585                	addi	a1,a1,1
  34:	0785                	addi	a5,a5,1
  36:	fff5c703          	lbu	a4,-1(a1)
  3a:	fee78fa3          	sb	a4,-1(a5)
  3e:	fb75                	bnez	a4,32 <strcpy+0x8>
    ;
  return os;
}
  40:	6422                	ld	s0,8(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  46:	1141                	addi	sp,sp,-16
  48:	e422                	sd	s0,8(sp)
  4a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4c:	00054783          	lbu	a5,0(a0)
  50:	cb91                	beqz	a5,64 <strcmp+0x1e>
  52:	0005c703          	lbu	a4,0(a1)
  56:	00f71763          	bne	a4,a5,64 <strcmp+0x1e>
    p++, q++;
  5a:	0505                	addi	a0,a0,1
  5c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	fbe5                	bnez	a5,52 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  64:	0005c503          	lbu	a0,0(a1)
}
  68:	40a7853b          	subw	a0,a5,a0
  6c:	6422                	ld	s0,8(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e422                	sd	s0,8(sp)
  76:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf91                	beqz	a5,98 <strlen+0x26>
  7e:	0505                	addi	a0,a0,1
  80:	87aa                	mv	a5,a0
  82:	86be                	mv	a3,a5
  84:	0785                	addi	a5,a5,1
  86:	fff7c703          	lbu	a4,-1(a5)
  8a:	ff65                	bnez	a4,82 <strlen+0x10>
  8c:	40a6853b          	subw	a0,a3,a0
  90:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret
  for(n = 0; s[n]; n++)
  98:	4501                	li	a0,0
  9a:	bfe5                	j	92 <strlen+0x20>

000000000000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e422                	sd	s0,8(sp)
  a0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a2:	ca19                	beqz	a2,b8 <memset+0x1c>
  a4:	87aa                	mv	a5,a0
  a6:	1602                	slli	a2,a2,0x20
  a8:	9201                	srli	a2,a2,0x20
  aa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ae:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b2:	0785                	addi	a5,a5,1
  b4:	fee79de3          	bne	a5,a4,ae <memset+0x12>
  }
  return dst;
}
  b8:	6422                	ld	s0,8(sp)
  ba:	0141                	addi	sp,sp,16
  bc:	8082                	ret

00000000000000be <strchr>:

char*
strchr(const char *s, char c)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e422                	sd	s0,8(sp)
  c2:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb99                	beqz	a5,de <strchr+0x20>
    if(*s == c)
  ca:	00f58763          	beq	a1,a5,d8 <strchr+0x1a>
  for(; *s; s++)
  ce:	0505                	addi	a0,a0,1
  d0:	00054783          	lbu	a5,0(a0)
  d4:	fbfd                	bnez	a5,ca <strchr+0xc>
      return (char*)s;
  return 0;
  d6:	4501                	li	a0,0
}
  d8:	6422                	ld	s0,8(sp)
  da:	0141                	addi	sp,sp,16
  dc:	8082                	ret
  return 0;
  de:	4501                	li	a0,0
  e0:	bfe5                	j	d8 <strchr+0x1a>

00000000000000e2 <gets>:

char*
gets(char *buf, int max)
{
  e2:	711d                	addi	sp,sp,-96
  e4:	ec86                	sd	ra,88(sp)
  e6:	e8a2                	sd	s0,80(sp)
  e8:	e4a6                	sd	s1,72(sp)
  ea:	e0ca                	sd	s2,64(sp)
  ec:	fc4e                	sd	s3,56(sp)
  ee:	f852                	sd	s4,48(sp)
  f0:	f456                	sd	s5,40(sp)
  f2:	f05a                	sd	s6,32(sp)
  f4:	ec5e                	sd	s7,24(sp)
  f6:	1080                	addi	s0,sp,96
  f8:	8baa                	mv	s7,a0
  fa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fc:	892a                	mv	s2,a0
  fe:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 100:	4aa9                	li	s5,10
 102:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 104:	89a6                	mv	s3,s1
 106:	2485                	addiw	s1,s1,1
 108:	0344d863          	bge	s1,s4,138 <gets+0x56>
    cc = read(0, &c, 1);
 10c:	4605                	li	a2,1
 10e:	faf40593          	addi	a1,s0,-81
 112:	4501                	li	a0,0
 114:	00000097          	auipc	ra,0x0
 118:	19a080e7          	jalr	410(ra) # 2ae <read>
    if(cc < 1)
 11c:	00a05e63          	blez	a0,138 <gets+0x56>
    buf[i++] = c;
 120:	faf44783          	lbu	a5,-81(s0)
 124:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 128:	01578763          	beq	a5,s5,136 <gets+0x54>
 12c:	0905                	addi	s2,s2,1
 12e:	fd679be3          	bne	a5,s6,104 <gets+0x22>
    buf[i++] = c;
 132:	89a6                	mv	s3,s1
 134:	a011                	j	138 <gets+0x56>
 136:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 138:	99de                	add	s3,s3,s7
 13a:	00098023          	sb	zero,0(s3)
  return buf;
}
 13e:	855e                	mv	a0,s7
 140:	60e6                	ld	ra,88(sp)
 142:	6446                	ld	s0,80(sp)
 144:	64a6                	ld	s1,72(sp)
 146:	6906                	ld	s2,64(sp)
 148:	79e2                	ld	s3,56(sp)
 14a:	7a42                	ld	s4,48(sp)
 14c:	7aa2                	ld	s5,40(sp)
 14e:	7b02                	ld	s6,32(sp)
 150:	6be2                	ld	s7,24(sp)
 152:	6125                	addi	sp,sp,96
 154:	8082                	ret

0000000000000156 <stat>:

int
stat(const char *n, struct stat *st)
{
 156:	1101                	addi	sp,sp,-32
 158:	ec06                	sd	ra,24(sp)
 15a:	e822                	sd	s0,16(sp)
 15c:	e04a                	sd	s2,0(sp)
 15e:	1000                	addi	s0,sp,32
 160:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 162:	4581                	li	a1,0
 164:	00000097          	auipc	ra,0x0
 168:	172080e7          	jalr	370(ra) # 2d6 <open>
  if(fd < 0)
 16c:	02054663          	bltz	a0,198 <stat+0x42>
 170:	e426                	sd	s1,8(sp)
 172:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 174:	85ca                	mv	a1,s2
 176:	00000097          	auipc	ra,0x0
 17a:	178080e7          	jalr	376(ra) # 2ee <fstat>
 17e:	892a                	mv	s2,a0
  close(fd);
 180:	8526                	mv	a0,s1
 182:	00000097          	auipc	ra,0x0
 186:	13c080e7          	jalr	316(ra) # 2be <close>
  return r;
 18a:	64a2                	ld	s1,8(sp)
}
 18c:	854a                	mv	a0,s2
 18e:	60e2                	ld	ra,24(sp)
 190:	6442                	ld	s0,16(sp)
 192:	6902                	ld	s2,0(sp)
 194:	6105                	addi	sp,sp,32
 196:	8082                	ret
    return -1;
 198:	597d                	li	s2,-1
 19a:	bfcd                	j	18c <stat+0x36>

000000000000019c <atoi>:

int
atoi(const char *s)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e422                	sd	s0,8(sp)
 1a0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a2:	00054683          	lbu	a3,0(a0)
 1a6:	fd06879b          	addiw	a5,a3,-48
 1aa:	0ff7f793          	zext.b	a5,a5
 1ae:	4625                	li	a2,9
 1b0:	02f66863          	bltu	a2,a5,1e0 <atoi+0x44>
 1b4:	872a                	mv	a4,a0
  n = 0;
 1b6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1b8:	0705                	addi	a4,a4,1
 1ba:	0025179b          	slliw	a5,a0,0x2
 1be:	9fa9                	addw	a5,a5,a0
 1c0:	0017979b          	slliw	a5,a5,0x1
 1c4:	9fb5                	addw	a5,a5,a3
 1c6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ca:	00074683          	lbu	a3,0(a4)
 1ce:	fd06879b          	addiw	a5,a3,-48
 1d2:	0ff7f793          	zext.b	a5,a5
 1d6:	fef671e3          	bgeu	a2,a5,1b8 <atoi+0x1c>
  return n;
}
 1da:	6422                	ld	s0,8(sp)
 1dc:	0141                	addi	sp,sp,16
 1de:	8082                	ret
  n = 0;
 1e0:	4501                	li	a0,0
 1e2:	bfe5                	j	1da <atoi+0x3e>

00000000000001e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e4:	1141                	addi	sp,sp,-16
 1e6:	e422                	sd	s0,8(sp)
 1e8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1ea:	02b57463          	bgeu	a0,a1,212 <memmove+0x2e>
    while(n-- > 0)
 1ee:	00c05f63          	blez	a2,20c <memmove+0x28>
 1f2:	1602                	slli	a2,a2,0x20
 1f4:	9201                	srli	a2,a2,0x20
 1f6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1fa:	872a                	mv	a4,a0
      *dst++ = *src++;
 1fc:	0585                	addi	a1,a1,1
 1fe:	0705                	addi	a4,a4,1
 200:	fff5c683          	lbu	a3,-1(a1)
 204:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 208:	fef71ae3          	bne	a4,a5,1fc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 20c:	6422                	ld	s0,8(sp)
 20e:	0141                	addi	sp,sp,16
 210:	8082                	ret
    dst += n;
 212:	00c50733          	add	a4,a0,a2
    src += n;
 216:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 218:	fec05ae3          	blez	a2,20c <memmove+0x28>
 21c:	fff6079b          	addiw	a5,a2,-1
 220:	1782                	slli	a5,a5,0x20
 222:	9381                	srli	a5,a5,0x20
 224:	fff7c793          	not	a5,a5
 228:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 22a:	15fd                	addi	a1,a1,-1
 22c:	177d                	addi	a4,a4,-1
 22e:	0005c683          	lbu	a3,0(a1)
 232:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 236:	fee79ae3          	bne	a5,a4,22a <memmove+0x46>
 23a:	bfc9                	j	20c <memmove+0x28>

000000000000023c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 23c:	1141                	addi	sp,sp,-16
 23e:	e422                	sd	s0,8(sp)
 240:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 242:	ca05                	beqz	a2,272 <memcmp+0x36>
 244:	fff6069b          	addiw	a3,a2,-1
 248:	1682                	slli	a3,a3,0x20
 24a:	9281                	srli	a3,a3,0x20
 24c:	0685                	addi	a3,a3,1
 24e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 250:	00054783          	lbu	a5,0(a0)
 254:	0005c703          	lbu	a4,0(a1)
 258:	00e79863          	bne	a5,a4,268 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 25c:	0505                	addi	a0,a0,1
    p2++;
 25e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 260:	fed518e3          	bne	a0,a3,250 <memcmp+0x14>
  }
  return 0;
 264:	4501                	li	a0,0
 266:	a019                	j	26c <memcmp+0x30>
      return *p1 - *p2;
 268:	40e7853b          	subw	a0,a5,a4
}
 26c:	6422                	ld	s0,8(sp)
 26e:	0141                	addi	sp,sp,16
 270:	8082                	ret
  return 0;
 272:	4501                	li	a0,0
 274:	bfe5                	j	26c <memcmp+0x30>

0000000000000276 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 276:	1141                	addi	sp,sp,-16
 278:	e406                	sd	ra,8(sp)
 27a:	e022                	sd	s0,0(sp)
 27c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 27e:	00000097          	auipc	ra,0x0
 282:	f66080e7          	jalr	-154(ra) # 1e4 <memmove>
}
 286:	60a2                	ld	ra,8(sp)
 288:	6402                	ld	s0,0(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret

000000000000028e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 28e:	4885                	li	a7,1
 ecall
 290:	00000073          	ecall
 ret
 294:	8082                	ret

0000000000000296 <exit>:
.global exit
exit:
 li a7, SYS_exit
 296:	4889                	li	a7,2
 ecall
 298:	00000073          	ecall
 ret
 29c:	8082                	ret

000000000000029e <wait>:
.global wait
wait:
 li a7, SYS_wait
 29e:	488d                	li	a7,3
 ecall
 2a0:	00000073          	ecall
 ret
 2a4:	8082                	ret

00000000000002a6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2a6:	4891                	li	a7,4
 ecall
 2a8:	00000073          	ecall
 ret
 2ac:	8082                	ret

00000000000002ae <read>:
.global read
read:
 li a7, SYS_read
 2ae:	4895                	li	a7,5
 ecall
 2b0:	00000073          	ecall
 ret
 2b4:	8082                	ret

00000000000002b6 <write>:
.global write
write:
 li a7, SYS_write
 2b6:	48c1                	li	a7,16
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <close>:
.global close
close:
 li a7, SYS_close
 2be:	48d5                	li	a7,21
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2c6:	4899                	li	a7,6
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <exec>:
.global exec
exec:
 li a7, SYS_exec
 2ce:	489d                	li	a7,7
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <open>:
.global open
open:
 li a7, SYS_open
 2d6:	48bd                	li	a7,15
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2de:	48c5                	li	a7,17
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2e6:	48c9                	li	a7,18
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2ee:	48a1                	li	a7,8
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <link>:
.global link
link:
 li a7, SYS_link
 2f6:	48cd                	li	a7,19
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2fe:	48d1                	li	a7,20
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 306:	48a5                	li	a7,9
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <dup>:
.global dup
dup:
 li a7, SYS_dup
 30e:	48a9                	li	a7,10
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 316:	48ad                	li	a7,11
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 31e:	48b1                	li	a7,12
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 326:	48b5                	li	a7,13
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 32e:	48b9                	li	a7,14
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 336:	1101                	addi	sp,sp,-32
 338:	ec06                	sd	ra,24(sp)
 33a:	e822                	sd	s0,16(sp)
 33c:	1000                	addi	s0,sp,32
 33e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 342:	4605                	li	a2,1
 344:	fef40593          	addi	a1,s0,-17
 348:	00000097          	auipc	ra,0x0
 34c:	f6e080e7          	jalr	-146(ra) # 2b6 <write>
}
 350:	60e2                	ld	ra,24(sp)
 352:	6442                	ld	s0,16(sp)
 354:	6105                	addi	sp,sp,32
 356:	8082                	ret

0000000000000358 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 358:	7139                	addi	sp,sp,-64
 35a:	fc06                	sd	ra,56(sp)
 35c:	f822                	sd	s0,48(sp)
 35e:	f426                	sd	s1,40(sp)
 360:	0080                	addi	s0,sp,64
 362:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 364:	c299                	beqz	a3,36a <printint+0x12>
 366:	0805cb63          	bltz	a1,3fc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 36a:	2581                	sext.w	a1,a1
  neg = 0;
 36c:	4881                	li	a7,0
 36e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 372:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 374:	2601                	sext.w	a2,a2
 376:	00000517          	auipc	a0,0x0
 37a:	4a250513          	addi	a0,a0,1186 # 818 <digits>
 37e:	883a                	mv	a6,a4
 380:	2705                	addiw	a4,a4,1
 382:	02c5f7bb          	remuw	a5,a1,a2
 386:	1782                	slli	a5,a5,0x20
 388:	9381                	srli	a5,a5,0x20
 38a:	97aa                	add	a5,a5,a0
 38c:	0007c783          	lbu	a5,0(a5)
 390:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 394:	0005879b          	sext.w	a5,a1
 398:	02c5d5bb          	divuw	a1,a1,a2
 39c:	0685                	addi	a3,a3,1
 39e:	fec7f0e3          	bgeu	a5,a2,37e <printint+0x26>
  if(neg)
 3a2:	00088c63          	beqz	a7,3ba <printint+0x62>
    buf[i++] = '-';
 3a6:	fd070793          	addi	a5,a4,-48
 3aa:	00878733          	add	a4,a5,s0
 3ae:	02d00793          	li	a5,45
 3b2:	fef70823          	sb	a5,-16(a4)
 3b6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ba:	02e05c63          	blez	a4,3f2 <printint+0x9a>
 3be:	f04a                	sd	s2,32(sp)
 3c0:	ec4e                	sd	s3,24(sp)
 3c2:	fc040793          	addi	a5,s0,-64
 3c6:	00e78933          	add	s2,a5,a4
 3ca:	fff78993          	addi	s3,a5,-1
 3ce:	99ba                	add	s3,s3,a4
 3d0:	377d                	addiw	a4,a4,-1
 3d2:	1702                	slli	a4,a4,0x20
 3d4:	9301                	srli	a4,a4,0x20
 3d6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3da:	fff94583          	lbu	a1,-1(s2)
 3de:	8526                	mv	a0,s1
 3e0:	00000097          	auipc	ra,0x0
 3e4:	f56080e7          	jalr	-170(ra) # 336 <putc>
  while(--i >= 0)
 3e8:	197d                	addi	s2,s2,-1
 3ea:	ff3918e3          	bne	s2,s3,3da <printint+0x82>
 3ee:	7902                	ld	s2,32(sp)
 3f0:	69e2                	ld	s3,24(sp)
}
 3f2:	70e2                	ld	ra,56(sp)
 3f4:	7442                	ld	s0,48(sp)
 3f6:	74a2                	ld	s1,40(sp)
 3f8:	6121                	addi	sp,sp,64
 3fa:	8082                	ret
    x = -xx;
 3fc:	40b005bb          	negw	a1,a1
    neg = 1;
 400:	4885                	li	a7,1
    x = -xx;
 402:	b7b5                	j	36e <printint+0x16>

0000000000000404 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 404:	715d                	addi	sp,sp,-80
 406:	e486                	sd	ra,72(sp)
 408:	e0a2                	sd	s0,64(sp)
 40a:	f84a                	sd	s2,48(sp)
 40c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 40e:	0005c903          	lbu	s2,0(a1)
 412:	1a090a63          	beqz	s2,5c6 <vprintf+0x1c2>
 416:	fc26                	sd	s1,56(sp)
 418:	f44e                	sd	s3,40(sp)
 41a:	f052                	sd	s4,32(sp)
 41c:	ec56                	sd	s5,24(sp)
 41e:	e85a                	sd	s6,16(sp)
 420:	e45e                	sd	s7,8(sp)
 422:	8aaa                	mv	s5,a0
 424:	8bb2                	mv	s7,a2
 426:	00158493          	addi	s1,a1,1
  state = 0;
 42a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 42c:	02500a13          	li	s4,37
 430:	4b55                	li	s6,21
 432:	a839                	j	450 <vprintf+0x4c>
        putc(fd, c);
 434:	85ca                	mv	a1,s2
 436:	8556                	mv	a0,s5
 438:	00000097          	auipc	ra,0x0
 43c:	efe080e7          	jalr	-258(ra) # 336 <putc>
 440:	a019                	j	446 <vprintf+0x42>
    } else if(state == '%'){
 442:	01498d63          	beq	s3,s4,45c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 446:	0485                	addi	s1,s1,1
 448:	fff4c903          	lbu	s2,-1(s1)
 44c:	16090763          	beqz	s2,5ba <vprintf+0x1b6>
    if(state == 0){
 450:	fe0999e3          	bnez	s3,442 <vprintf+0x3e>
      if(c == '%'){
 454:	ff4910e3          	bne	s2,s4,434 <vprintf+0x30>
        state = '%';
 458:	89d2                	mv	s3,s4
 45a:	b7f5                	j	446 <vprintf+0x42>
      if(c == 'd'){
 45c:	13490463          	beq	s2,s4,584 <vprintf+0x180>
 460:	f9d9079b          	addiw	a5,s2,-99
 464:	0ff7f793          	zext.b	a5,a5
 468:	12fb6763          	bltu	s6,a5,596 <vprintf+0x192>
 46c:	f9d9079b          	addiw	a5,s2,-99
 470:	0ff7f713          	zext.b	a4,a5
 474:	12eb6163          	bltu	s6,a4,596 <vprintf+0x192>
 478:	00271793          	slli	a5,a4,0x2
 47c:	00000717          	auipc	a4,0x0
 480:	34470713          	addi	a4,a4,836 # 7c0 <malloc+0x10a>
 484:	97ba                	add	a5,a5,a4
 486:	439c                	lw	a5,0(a5)
 488:	97ba                	add	a5,a5,a4
 48a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 48c:	008b8913          	addi	s2,s7,8
 490:	4685                	li	a3,1
 492:	4629                	li	a2,10
 494:	000ba583          	lw	a1,0(s7)
 498:	8556                	mv	a0,s5
 49a:	00000097          	auipc	ra,0x0
 49e:	ebe080e7          	jalr	-322(ra) # 358 <printint>
 4a2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4a4:	4981                	li	s3,0
 4a6:	b745                	j	446 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4a8:	008b8913          	addi	s2,s7,8
 4ac:	4681                	li	a3,0
 4ae:	4629                	li	a2,10
 4b0:	000ba583          	lw	a1,0(s7)
 4b4:	8556                	mv	a0,s5
 4b6:	00000097          	auipc	ra,0x0
 4ba:	ea2080e7          	jalr	-350(ra) # 358 <printint>
 4be:	8bca                	mv	s7,s2
      state = 0;
 4c0:	4981                	li	s3,0
 4c2:	b751                	j	446 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4c4:	008b8913          	addi	s2,s7,8
 4c8:	4681                	li	a3,0
 4ca:	4641                	li	a2,16
 4cc:	000ba583          	lw	a1,0(s7)
 4d0:	8556                	mv	a0,s5
 4d2:	00000097          	auipc	ra,0x0
 4d6:	e86080e7          	jalr	-378(ra) # 358 <printint>
 4da:	8bca                	mv	s7,s2
      state = 0;
 4dc:	4981                	li	s3,0
 4de:	b7a5                	j	446 <vprintf+0x42>
 4e0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 4e2:	008b8c13          	addi	s8,s7,8
 4e6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 4ea:	03000593          	li	a1,48
 4ee:	8556                	mv	a0,s5
 4f0:	00000097          	auipc	ra,0x0
 4f4:	e46080e7          	jalr	-442(ra) # 336 <putc>
  putc(fd, 'x');
 4f8:	07800593          	li	a1,120
 4fc:	8556                	mv	a0,s5
 4fe:	00000097          	auipc	ra,0x0
 502:	e38080e7          	jalr	-456(ra) # 336 <putc>
 506:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 508:	00000b97          	auipc	s7,0x0
 50c:	310b8b93          	addi	s7,s7,784 # 818 <digits>
 510:	03c9d793          	srli	a5,s3,0x3c
 514:	97de                	add	a5,a5,s7
 516:	0007c583          	lbu	a1,0(a5)
 51a:	8556                	mv	a0,s5
 51c:	00000097          	auipc	ra,0x0
 520:	e1a080e7          	jalr	-486(ra) # 336 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 524:	0992                	slli	s3,s3,0x4
 526:	397d                	addiw	s2,s2,-1
 528:	fe0914e3          	bnez	s2,510 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 52c:	8be2                	mv	s7,s8
      state = 0;
 52e:	4981                	li	s3,0
 530:	6c02                	ld	s8,0(sp)
 532:	bf11                	j	446 <vprintf+0x42>
        s = va_arg(ap, char*);
 534:	008b8993          	addi	s3,s7,8
 538:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 53c:	02090163          	beqz	s2,55e <vprintf+0x15a>
        while(*s != 0){
 540:	00094583          	lbu	a1,0(s2)
 544:	c9a5                	beqz	a1,5b4 <vprintf+0x1b0>
          putc(fd, *s);
 546:	8556                	mv	a0,s5
 548:	00000097          	auipc	ra,0x0
 54c:	dee080e7          	jalr	-530(ra) # 336 <putc>
          s++;
 550:	0905                	addi	s2,s2,1
        while(*s != 0){
 552:	00094583          	lbu	a1,0(s2)
 556:	f9e5                	bnez	a1,546 <vprintf+0x142>
        s = va_arg(ap, char*);
 558:	8bce                	mv	s7,s3
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b5ed                	j	446 <vprintf+0x42>
          s = "(null)";
 55e:	00000917          	auipc	s2,0x0
 562:	25a90913          	addi	s2,s2,602 # 7b8 <malloc+0x102>
        while(*s != 0){
 566:	02800593          	li	a1,40
 56a:	bff1                	j	546 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 56c:	008b8913          	addi	s2,s7,8
 570:	000bc583          	lbu	a1,0(s7)
 574:	8556                	mv	a0,s5
 576:	00000097          	auipc	ra,0x0
 57a:	dc0080e7          	jalr	-576(ra) # 336 <putc>
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	b5d1                	j	446 <vprintf+0x42>
        putc(fd, c);
 584:	02500593          	li	a1,37
 588:	8556                	mv	a0,s5
 58a:	00000097          	auipc	ra,0x0
 58e:	dac080e7          	jalr	-596(ra) # 336 <putc>
      state = 0;
 592:	4981                	li	s3,0
 594:	bd4d                	j	446 <vprintf+0x42>
        putc(fd, '%');
 596:	02500593          	li	a1,37
 59a:	8556                	mv	a0,s5
 59c:	00000097          	auipc	ra,0x0
 5a0:	d9a080e7          	jalr	-614(ra) # 336 <putc>
        putc(fd, c);
 5a4:	85ca                	mv	a1,s2
 5a6:	8556                	mv	a0,s5
 5a8:	00000097          	auipc	ra,0x0
 5ac:	d8e080e7          	jalr	-626(ra) # 336 <putc>
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	bd51                	j	446 <vprintf+0x42>
        s = va_arg(ap, char*);
 5b4:	8bce                	mv	s7,s3
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b579                	j	446 <vprintf+0x42>
 5ba:	74e2                	ld	s1,56(sp)
 5bc:	79a2                	ld	s3,40(sp)
 5be:	7a02                	ld	s4,32(sp)
 5c0:	6ae2                	ld	s5,24(sp)
 5c2:	6b42                	ld	s6,16(sp)
 5c4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5c6:	60a6                	ld	ra,72(sp)
 5c8:	6406                	ld	s0,64(sp)
 5ca:	7942                	ld	s2,48(sp)
 5cc:	6161                	addi	sp,sp,80
 5ce:	8082                	ret

00000000000005d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 5d0:	715d                	addi	sp,sp,-80
 5d2:	ec06                	sd	ra,24(sp)
 5d4:	e822                	sd	s0,16(sp)
 5d6:	1000                	addi	s0,sp,32
 5d8:	e010                	sd	a2,0(s0)
 5da:	e414                	sd	a3,8(s0)
 5dc:	e818                	sd	a4,16(s0)
 5de:	ec1c                	sd	a5,24(s0)
 5e0:	03043023          	sd	a6,32(s0)
 5e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 5e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 5ec:	8622                	mv	a2,s0
 5ee:	00000097          	auipc	ra,0x0
 5f2:	e16080e7          	jalr	-490(ra) # 404 <vprintf>
}
 5f6:	60e2                	ld	ra,24(sp)
 5f8:	6442                	ld	s0,16(sp)
 5fa:	6161                	addi	sp,sp,80
 5fc:	8082                	ret

00000000000005fe <printf>:

void
printf(const char *fmt, ...)
{
 5fe:	711d                	addi	sp,sp,-96
 600:	ec06                	sd	ra,24(sp)
 602:	e822                	sd	s0,16(sp)
 604:	1000                	addi	s0,sp,32
 606:	e40c                	sd	a1,8(s0)
 608:	e810                	sd	a2,16(s0)
 60a:	ec14                	sd	a3,24(s0)
 60c:	f018                	sd	a4,32(s0)
 60e:	f41c                	sd	a5,40(s0)
 610:	03043823          	sd	a6,48(s0)
 614:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 618:	00840613          	addi	a2,s0,8
 61c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 620:	85aa                	mv	a1,a0
 622:	4505                	li	a0,1
 624:	00000097          	auipc	ra,0x0
 628:	de0080e7          	jalr	-544(ra) # 404 <vprintf>
}
 62c:	60e2                	ld	ra,24(sp)
 62e:	6442                	ld	s0,16(sp)
 630:	6125                	addi	sp,sp,96
 632:	8082                	ret

0000000000000634 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 634:	1141                	addi	sp,sp,-16
 636:	e422                	sd	s0,8(sp)
 638:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 63a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63e:	00000797          	auipc	a5,0x0
 642:	5aa7b783          	ld	a5,1450(a5) # be8 <freep>
 646:	a02d                	j	670 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 648:	4618                	lw	a4,8(a2)
 64a:	9f2d                	addw	a4,a4,a1
 64c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 650:	6398                	ld	a4,0(a5)
 652:	6310                	ld	a2,0(a4)
 654:	a83d                	j	692 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 656:	ff852703          	lw	a4,-8(a0)
 65a:	9f31                	addw	a4,a4,a2
 65c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 65e:	ff053683          	ld	a3,-16(a0)
 662:	a091                	j	6a6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 664:	6398                	ld	a4,0(a5)
 666:	00e7e463          	bltu	a5,a4,66e <free+0x3a>
 66a:	00e6ea63          	bltu	a3,a4,67e <free+0x4a>
{
 66e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 670:	fed7fae3          	bgeu	a5,a3,664 <free+0x30>
 674:	6398                	ld	a4,0(a5)
 676:	00e6e463          	bltu	a3,a4,67e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 67a:	fee7eae3          	bltu	a5,a4,66e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 67e:	ff852583          	lw	a1,-8(a0)
 682:	6390                	ld	a2,0(a5)
 684:	02059813          	slli	a6,a1,0x20
 688:	01c85713          	srli	a4,a6,0x1c
 68c:	9736                	add	a4,a4,a3
 68e:	fae60de3          	beq	a2,a4,648 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 692:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 696:	4790                	lw	a2,8(a5)
 698:	02061593          	slli	a1,a2,0x20
 69c:	01c5d713          	srli	a4,a1,0x1c
 6a0:	973e                	add	a4,a4,a5
 6a2:	fae68ae3          	beq	a3,a4,656 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6a6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6a8:	00000717          	auipc	a4,0x0
 6ac:	54f73023          	sd	a5,1344(a4) # be8 <freep>
}
 6b0:	6422                	ld	s0,8(sp)
 6b2:	0141                	addi	sp,sp,16
 6b4:	8082                	ret

00000000000006b6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b6:	7139                	addi	sp,sp,-64
 6b8:	fc06                	sd	ra,56(sp)
 6ba:	f822                	sd	s0,48(sp)
 6bc:	f426                	sd	s1,40(sp)
 6be:	ec4e                	sd	s3,24(sp)
 6c0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c2:	02051493          	slli	s1,a0,0x20
 6c6:	9081                	srli	s1,s1,0x20
 6c8:	04bd                	addi	s1,s1,15
 6ca:	8091                	srli	s1,s1,0x4
 6cc:	0014899b          	addiw	s3,s1,1
 6d0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 6d2:	00000517          	auipc	a0,0x0
 6d6:	51653503          	ld	a0,1302(a0) # be8 <freep>
 6da:	c915                	beqz	a0,70e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 6de:	4798                	lw	a4,8(a5)
 6e0:	08977e63          	bgeu	a4,s1,77c <malloc+0xc6>
 6e4:	f04a                	sd	s2,32(sp)
 6e6:	e852                	sd	s4,16(sp)
 6e8:	e456                	sd	s5,8(sp)
 6ea:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 6ec:	8a4e                	mv	s4,s3
 6ee:	0009871b          	sext.w	a4,s3
 6f2:	6685                	lui	a3,0x1
 6f4:	00d77363          	bgeu	a4,a3,6fa <malloc+0x44>
 6f8:	6a05                	lui	s4,0x1
 6fa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 6fe:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 702:	00000917          	auipc	s2,0x0
 706:	4e690913          	addi	s2,s2,1254 # be8 <freep>
  if(p == (char*)-1)
 70a:	5afd                	li	s5,-1
 70c:	a091                	j	750 <malloc+0x9a>
 70e:	f04a                	sd	s2,32(sp)
 710:	e852                	sd	s4,16(sp)
 712:	e456                	sd	s5,8(sp)
 714:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 716:	00000797          	auipc	a5,0x0
 71a:	4da78793          	addi	a5,a5,1242 # bf0 <base>
 71e:	00000717          	auipc	a4,0x0
 722:	4cf73523          	sd	a5,1226(a4) # be8 <freep>
 726:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 728:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 72c:	b7c1                	j	6ec <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 72e:	6398                	ld	a4,0(a5)
 730:	e118                	sd	a4,0(a0)
 732:	a08d                	j	794 <malloc+0xde>
  hp->s.size = nu;
 734:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 738:	0541                	addi	a0,a0,16
 73a:	00000097          	auipc	ra,0x0
 73e:	efa080e7          	jalr	-262(ra) # 634 <free>
  return freep;
 742:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 746:	c13d                	beqz	a0,7ac <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 748:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 74a:	4798                	lw	a4,8(a5)
 74c:	02977463          	bgeu	a4,s1,774 <malloc+0xbe>
    if(p == freep)
 750:	00093703          	ld	a4,0(s2)
 754:	853e                	mv	a0,a5
 756:	fef719e3          	bne	a4,a5,748 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 75a:	8552                	mv	a0,s4
 75c:	00000097          	auipc	ra,0x0
 760:	bc2080e7          	jalr	-1086(ra) # 31e <sbrk>
  if(p == (char*)-1)
 764:	fd5518e3          	bne	a0,s5,734 <malloc+0x7e>
        return 0;
 768:	4501                	li	a0,0
 76a:	7902                	ld	s2,32(sp)
 76c:	6a42                	ld	s4,16(sp)
 76e:	6aa2                	ld	s5,8(sp)
 770:	6b02                	ld	s6,0(sp)
 772:	a03d                	j	7a0 <malloc+0xea>
 774:	7902                	ld	s2,32(sp)
 776:	6a42                	ld	s4,16(sp)
 778:	6aa2                	ld	s5,8(sp)
 77a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 77c:	fae489e3          	beq	s1,a4,72e <malloc+0x78>
        p->s.size -= nunits;
 780:	4137073b          	subw	a4,a4,s3
 784:	c798                	sw	a4,8(a5)
        p += p->s.size;
 786:	02071693          	slli	a3,a4,0x20
 78a:	01c6d713          	srli	a4,a3,0x1c
 78e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 790:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 794:	00000717          	auipc	a4,0x0
 798:	44a73a23          	sd	a0,1108(a4) # be8 <freep>
      return (void*)(p + 1);
 79c:	01078513          	addi	a0,a5,16
  }
}
 7a0:	70e2                	ld	ra,56(sp)
 7a2:	7442                	ld	s0,48(sp)
 7a4:	74a2                	ld	s1,40(sp)
 7a6:	69e2                	ld	s3,24(sp)
 7a8:	6121                	addi	sp,sp,64
 7aa:	8082                	ret
 7ac:	7902                	ld	s2,32(sp)
 7ae:	6a42                	ld	s4,16(sp)
 7b0:	6aa2                	ld	s5,8(sp)
 7b2:	6b02                	ld	s6,0(sp)
 7b4:	b7f5                	j	7a0 <malloc+0xea>
