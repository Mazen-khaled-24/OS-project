
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	02f50163          	beq	a0,a5,2c <main+0x2c>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00000597          	auipc	a1,0x0
  14:	7e058593          	addi	a1,a1,2016 # 7f0 <malloc+0x102>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	5ee080e7          	jalr	1518(ra) # 608 <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2aa080e7          	jalr	682(ra) # 2ce <exit>
  2c:	e426                	sd	s1,8(sp)
  2e:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  30:	698c                	ld	a1,16(a1)
  32:	6488                	ld	a0,8(s1)
  34:	00000097          	auipc	ra,0x0
  38:	2fa080e7          	jalr	762(ra) # 32e <link>
  3c:	00054763          	bltz	a0,4a <main+0x4a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  40:	4501                	li	a0,0
  42:	00000097          	auipc	ra,0x0
  46:	28c080e7          	jalr	652(ra) # 2ce <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4a:	6894                	ld	a3,16(s1)
  4c:	6490                	ld	a2,8(s1)
  4e:	00000597          	auipc	a1,0x0
  52:	7ba58593          	addi	a1,a1,1978 # 808 <malloc+0x11a>
  56:	4509                	li	a0,2
  58:	00000097          	auipc	ra,0x0
  5c:	5b0080e7          	jalr	1456(ra) # 608 <fprintf>
  60:	b7c5                	j	40 <main+0x40>

0000000000000062 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
  62:	1141                	addi	sp,sp,-16
  64:	e422                	sd	s0,8(sp)
  66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  68:	87aa                	mv	a5,a0
  6a:	0585                	addi	a1,a1,1
  6c:	0785                	addi	a5,a5,1
  6e:	fff5c703          	lbu	a4,-1(a1)
  72:	fee78fa3          	sb	a4,-1(a5)
  76:	fb75                	bnez	a4,6a <strcpy+0x8>
    ;
  return os;
}
  78:	6422                	ld	s0,8(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e422                	sd	s0,8(sp)
  82:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  84:	00054783          	lbu	a5,0(a0)
  88:	cb91                	beqz	a5,9c <strcmp+0x1e>
  8a:	0005c703          	lbu	a4,0(a1)
  8e:	00f71763          	bne	a4,a5,9c <strcmp+0x1e>
    p++, q++;
  92:	0505                	addi	a0,a0,1
  94:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  96:	00054783          	lbu	a5,0(a0)
  9a:	fbe5                	bnez	a5,8a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  9c:	0005c503          	lbu	a0,0(a1)
}
  a0:	40a7853b          	subw	a0,a5,a0
  a4:	6422                	ld	s0,8(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret

00000000000000aa <strlen>:

uint
strlen(const char *s)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e422                	sd	s0,8(sp)
  ae:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	cf91                	beqz	a5,d0 <strlen+0x26>
  b6:	0505                	addi	a0,a0,1
  b8:	87aa                	mv	a5,a0
  ba:	86be                	mv	a3,a5
  bc:	0785                	addi	a5,a5,1
  be:	fff7c703          	lbu	a4,-1(a5)
  c2:	ff65                	bnez	a4,ba <strlen+0x10>
  c4:	40a6853b          	subw	a0,a3,a0
  c8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ca:	6422                	ld	s0,8(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret
  for(n = 0; s[n]; n++)
  d0:	4501                	li	a0,0
  d2:	bfe5                	j	ca <strlen+0x20>

00000000000000d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e422                	sd	s0,8(sp)
  d8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  da:	ca19                	beqz	a2,f0 <memset+0x1c>
  dc:	87aa                	mv	a5,a0
  de:	1602                	slli	a2,a2,0x20
  e0:	9201                	srli	a2,a2,0x20
  e2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  e6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ea:	0785                	addi	a5,a5,1
  ec:	fee79de3          	bne	a5,a4,e6 <memset+0x12>
  }
  return dst;
}
  f0:	6422                	ld	s0,8(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strchr>:

char*
strchr(const char *s, char c)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e422                	sd	s0,8(sp)
  fa:	0800                	addi	s0,sp,16
  for(; *s; s++)
  fc:	00054783          	lbu	a5,0(a0)
 100:	cb99                	beqz	a5,116 <strchr+0x20>
    if(*s == c)
 102:	00f58763          	beq	a1,a5,110 <strchr+0x1a>
  for(; *s; s++)
 106:	0505                	addi	a0,a0,1
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbfd                	bnez	a5,102 <strchr+0xc>
      return (char*)s;
  return 0;
 10e:	4501                	li	a0,0
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	addi	sp,sp,16
 114:	8082                	ret
  return 0;
 116:	4501                	li	a0,0
 118:	bfe5                	j	110 <strchr+0x1a>

000000000000011a <gets>:

char*
gets(char *buf, int max)
{
 11a:	711d                	addi	sp,sp,-96
 11c:	ec86                	sd	ra,88(sp)
 11e:	e8a2                	sd	s0,80(sp)
 120:	e4a6                	sd	s1,72(sp)
 122:	e0ca                	sd	s2,64(sp)
 124:	fc4e                	sd	s3,56(sp)
 126:	f852                	sd	s4,48(sp)
 128:	f456                	sd	s5,40(sp)
 12a:	f05a                	sd	s6,32(sp)
 12c:	ec5e                	sd	s7,24(sp)
 12e:	1080                	addi	s0,sp,96
 130:	8baa                	mv	s7,a0
 132:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 134:	892a                	mv	s2,a0
 136:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 138:	4aa9                	li	s5,10
 13a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 13c:	89a6                	mv	s3,s1
 13e:	2485                	addiw	s1,s1,1
 140:	0344d863          	bge	s1,s4,170 <gets+0x56>
    cc = read(0, &c, 1);
 144:	4605                	li	a2,1
 146:	faf40593          	addi	a1,s0,-81
 14a:	4501                	li	a0,0
 14c:	00000097          	auipc	ra,0x0
 150:	19a080e7          	jalr	410(ra) # 2e6 <read>
    if(cc < 1)
 154:	00a05e63          	blez	a0,170 <gets+0x56>
    buf[i++] = c;
 158:	faf44783          	lbu	a5,-81(s0)
 15c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 160:	01578763          	beq	a5,s5,16e <gets+0x54>
 164:	0905                	addi	s2,s2,1
 166:	fd679be3          	bne	a5,s6,13c <gets+0x22>
    buf[i++] = c;
 16a:	89a6                	mv	s3,s1
 16c:	a011                	j	170 <gets+0x56>
 16e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 170:	99de                	add	s3,s3,s7
 172:	00098023          	sb	zero,0(s3)
  return buf;
}
 176:	855e                	mv	a0,s7
 178:	60e6                	ld	ra,88(sp)
 17a:	6446                	ld	s0,80(sp)
 17c:	64a6                	ld	s1,72(sp)
 17e:	6906                	ld	s2,64(sp)
 180:	79e2                	ld	s3,56(sp)
 182:	7a42                	ld	s4,48(sp)
 184:	7aa2                	ld	s5,40(sp)
 186:	7b02                	ld	s6,32(sp)
 188:	6be2                	ld	s7,24(sp)
 18a:	6125                	addi	sp,sp,96
 18c:	8082                	ret

000000000000018e <stat>:

int
stat(const char *n, struct stat *st)
{
 18e:	1101                	addi	sp,sp,-32
 190:	ec06                	sd	ra,24(sp)
 192:	e822                	sd	s0,16(sp)
 194:	e04a                	sd	s2,0(sp)
 196:	1000                	addi	s0,sp,32
 198:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	4581                	li	a1,0
 19c:	00000097          	auipc	ra,0x0
 1a0:	172080e7          	jalr	370(ra) # 30e <open>
  if(fd < 0)
 1a4:	02054663          	bltz	a0,1d0 <stat+0x42>
 1a8:	e426                	sd	s1,8(sp)
 1aa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ac:	85ca                	mv	a1,s2
 1ae:	00000097          	auipc	ra,0x0
 1b2:	178080e7          	jalr	376(ra) # 326 <fstat>
 1b6:	892a                	mv	s2,a0
  close(fd);
 1b8:	8526                	mv	a0,s1
 1ba:	00000097          	auipc	ra,0x0
 1be:	13c080e7          	jalr	316(ra) # 2f6 <close>
  return r;
 1c2:	64a2                	ld	s1,8(sp)
}
 1c4:	854a                	mv	a0,s2
 1c6:	60e2                	ld	ra,24(sp)
 1c8:	6442                	ld	s0,16(sp)
 1ca:	6902                	ld	s2,0(sp)
 1cc:	6105                	addi	sp,sp,32
 1ce:	8082                	ret
    return -1;
 1d0:	597d                	li	s2,-1
 1d2:	bfcd                	j	1c4 <stat+0x36>

00000000000001d4 <atoi>:

int
atoi(const char *s)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1da:	00054683          	lbu	a3,0(a0)
 1de:	fd06879b          	addiw	a5,a3,-48
 1e2:	0ff7f793          	zext.b	a5,a5
 1e6:	4625                	li	a2,9
 1e8:	02f66863          	bltu	a2,a5,218 <atoi+0x44>
 1ec:	872a                	mv	a4,a0
  n = 0;
 1ee:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f0:	0705                	addi	a4,a4,1
 1f2:	0025179b          	slliw	a5,a0,0x2
 1f6:	9fa9                	addw	a5,a5,a0
 1f8:	0017979b          	slliw	a5,a5,0x1
 1fc:	9fb5                	addw	a5,a5,a3
 1fe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 202:	00074683          	lbu	a3,0(a4)
 206:	fd06879b          	addiw	a5,a3,-48
 20a:	0ff7f793          	zext.b	a5,a5
 20e:	fef671e3          	bgeu	a2,a5,1f0 <atoi+0x1c>
  return n;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	addi	sp,sp,16
 216:	8082                	ret
  n = 0;
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <atoi+0x3e>

000000000000021c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 222:	02b57463          	bgeu	a0,a1,24a <memmove+0x2e>
    while(n-- > 0)
 226:	00c05f63          	blez	a2,244 <memmove+0x28>
 22a:	1602                	slli	a2,a2,0x20
 22c:	9201                	srli	a2,a2,0x20
 22e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 232:	872a                	mv	a4,a0
      *dst++ = *src++;
 234:	0585                	addi	a1,a1,1
 236:	0705                	addi	a4,a4,1
 238:	fff5c683          	lbu	a3,-1(a1)
 23c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 240:	fef71ae3          	bne	a4,a5,234 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 244:	6422                	ld	s0,8(sp)
 246:	0141                	addi	sp,sp,16
 248:	8082                	ret
    dst += n;
 24a:	00c50733          	add	a4,a0,a2
    src += n;
 24e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 250:	fec05ae3          	blez	a2,244 <memmove+0x28>
 254:	fff6079b          	addiw	a5,a2,-1
 258:	1782                	slli	a5,a5,0x20
 25a:	9381                	srli	a5,a5,0x20
 25c:	fff7c793          	not	a5,a5
 260:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 262:	15fd                	addi	a1,a1,-1
 264:	177d                	addi	a4,a4,-1
 266:	0005c683          	lbu	a3,0(a1)
 26a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 26e:	fee79ae3          	bne	a5,a4,262 <memmove+0x46>
 272:	bfc9                	j	244 <memmove+0x28>

0000000000000274 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 274:	1141                	addi	sp,sp,-16
 276:	e422                	sd	s0,8(sp)
 278:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 27a:	ca05                	beqz	a2,2aa <memcmp+0x36>
 27c:	fff6069b          	addiw	a3,a2,-1
 280:	1682                	slli	a3,a3,0x20
 282:	9281                	srli	a3,a3,0x20
 284:	0685                	addi	a3,a3,1
 286:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 288:	00054783          	lbu	a5,0(a0)
 28c:	0005c703          	lbu	a4,0(a1)
 290:	00e79863          	bne	a5,a4,2a0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 294:	0505                	addi	a0,a0,1
    p2++;
 296:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 298:	fed518e3          	bne	a0,a3,288 <memcmp+0x14>
  }
  return 0;
 29c:	4501                	li	a0,0
 29e:	a019                	j	2a4 <memcmp+0x30>
      return *p1 - *p2;
 2a0:	40e7853b          	subw	a0,a5,a4
}
 2a4:	6422                	ld	s0,8(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	bfe5                	j	2a4 <memcmp+0x30>

00000000000002ae <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e406                	sd	ra,8(sp)
 2b2:	e022                	sd	s0,0(sp)
 2b4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2b6:	00000097          	auipc	ra,0x0
 2ba:	f66080e7          	jalr	-154(ra) # 21c <memmove>
}
 2be:	60a2                	ld	ra,8(sp)
 2c0:	6402                	ld	s0,0(sp)
 2c2:	0141                	addi	sp,sp,16
 2c4:	8082                	ret

00000000000002c6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c6:	4885                	li	a7,1
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <exit>:
.global exit
exit:
 li a7, SYS_exit
 2ce:	4889                	li	a7,2
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d6:	488d                	li	a7,3
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2de:	4891                	li	a7,4
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <read>:
.global read
read:
 li a7, SYS_read
 2e6:	4895                	li	a7,5
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <write>:
.global write
write:
 li a7, SYS_write
 2ee:	48c1                	li	a7,16
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <close>:
.global close
close:
 li a7, SYS_close
 2f6:	48d5                	li	a7,21
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <kill>:
.global kill
kill:
 li a7, SYS_kill
 2fe:	4899                	li	a7,6
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <exec>:
.global exec
exec:
 li a7, SYS_exec
 306:	489d                	li	a7,7
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <open>:
.global open
open:
 li a7, SYS_open
 30e:	48bd                	li	a7,15
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 316:	48c5                	li	a7,17
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 31e:	48c9                	li	a7,18
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 326:	48a1                	li	a7,8
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <link>:
.global link
link:
 li a7, SYS_link
 32e:	48cd                	li	a7,19
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 336:	48d1                	li	a7,20
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 33e:	48a5                	li	a7,9
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <dup>:
.global dup
dup:
 li a7, SYS_dup
 346:	48a9                	li	a7,10
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 34e:	48ad                	li	a7,11
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 356:	48b1                	li	a7,12
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 35e:	48b5                	li	a7,13
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 366:	48b9                	li	a7,14
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 36e:	1101                	addi	sp,sp,-32
 370:	ec06                	sd	ra,24(sp)
 372:	e822                	sd	s0,16(sp)
 374:	1000                	addi	s0,sp,32
 376:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 37a:	4605                	li	a2,1
 37c:	fef40593          	addi	a1,s0,-17
 380:	00000097          	auipc	ra,0x0
 384:	f6e080e7          	jalr	-146(ra) # 2ee <write>
}
 388:	60e2                	ld	ra,24(sp)
 38a:	6442                	ld	s0,16(sp)
 38c:	6105                	addi	sp,sp,32
 38e:	8082                	ret

0000000000000390 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	7139                	addi	sp,sp,-64
 392:	fc06                	sd	ra,56(sp)
 394:	f822                	sd	s0,48(sp)
 396:	f426                	sd	s1,40(sp)
 398:	0080                	addi	s0,sp,64
 39a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39c:	c299                	beqz	a3,3a2 <printint+0x12>
 39e:	0805cb63          	bltz	a1,434 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a2:	2581                	sext.w	a1,a1
  neg = 0;
 3a4:	4881                	li	a7,0
 3a6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3aa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ac:	2601                	sext.w	a2,a2
 3ae:	00000517          	auipc	a0,0x0
 3b2:	4d250513          	addi	a0,a0,1234 # 880 <digits>
 3b6:	883a                	mv	a6,a4
 3b8:	2705                	addiw	a4,a4,1
 3ba:	02c5f7bb          	remuw	a5,a1,a2
 3be:	1782                	slli	a5,a5,0x20
 3c0:	9381                	srli	a5,a5,0x20
 3c2:	97aa                	add	a5,a5,a0
 3c4:	0007c783          	lbu	a5,0(a5)
 3c8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3cc:	0005879b          	sext.w	a5,a1
 3d0:	02c5d5bb          	divuw	a1,a1,a2
 3d4:	0685                	addi	a3,a3,1
 3d6:	fec7f0e3          	bgeu	a5,a2,3b6 <printint+0x26>
  if(neg)
 3da:	00088c63          	beqz	a7,3f2 <printint+0x62>
    buf[i++] = '-';
 3de:	fd070793          	addi	a5,a4,-48
 3e2:	00878733          	add	a4,a5,s0
 3e6:	02d00793          	li	a5,45
 3ea:	fef70823          	sb	a5,-16(a4)
 3ee:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3f2:	02e05c63          	blez	a4,42a <printint+0x9a>
 3f6:	f04a                	sd	s2,32(sp)
 3f8:	ec4e                	sd	s3,24(sp)
 3fa:	fc040793          	addi	a5,s0,-64
 3fe:	00e78933          	add	s2,a5,a4
 402:	fff78993          	addi	s3,a5,-1
 406:	99ba                	add	s3,s3,a4
 408:	377d                	addiw	a4,a4,-1
 40a:	1702                	slli	a4,a4,0x20
 40c:	9301                	srli	a4,a4,0x20
 40e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 412:	fff94583          	lbu	a1,-1(s2)
 416:	8526                	mv	a0,s1
 418:	00000097          	auipc	ra,0x0
 41c:	f56080e7          	jalr	-170(ra) # 36e <putc>
  while(--i >= 0)
 420:	197d                	addi	s2,s2,-1
 422:	ff3918e3          	bne	s2,s3,412 <printint+0x82>
 426:	7902                	ld	s2,32(sp)
 428:	69e2                	ld	s3,24(sp)
}
 42a:	70e2                	ld	ra,56(sp)
 42c:	7442                	ld	s0,48(sp)
 42e:	74a2                	ld	s1,40(sp)
 430:	6121                	addi	sp,sp,64
 432:	8082                	ret
    x = -xx;
 434:	40b005bb          	negw	a1,a1
    neg = 1;
 438:	4885                	li	a7,1
    x = -xx;
 43a:	b7b5                	j	3a6 <printint+0x16>

000000000000043c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 43c:	715d                	addi	sp,sp,-80
 43e:	e486                	sd	ra,72(sp)
 440:	e0a2                	sd	s0,64(sp)
 442:	f84a                	sd	s2,48(sp)
 444:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 446:	0005c903          	lbu	s2,0(a1)
 44a:	1a090a63          	beqz	s2,5fe <vprintf+0x1c2>
 44e:	fc26                	sd	s1,56(sp)
 450:	f44e                	sd	s3,40(sp)
 452:	f052                	sd	s4,32(sp)
 454:	ec56                	sd	s5,24(sp)
 456:	e85a                	sd	s6,16(sp)
 458:	e45e                	sd	s7,8(sp)
 45a:	8aaa                	mv	s5,a0
 45c:	8bb2                	mv	s7,a2
 45e:	00158493          	addi	s1,a1,1
  state = 0;
 462:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 464:	02500a13          	li	s4,37
 468:	4b55                	li	s6,21
 46a:	a839                	j	488 <vprintf+0x4c>
        putc(fd, c);
 46c:	85ca                	mv	a1,s2
 46e:	8556                	mv	a0,s5
 470:	00000097          	auipc	ra,0x0
 474:	efe080e7          	jalr	-258(ra) # 36e <putc>
 478:	a019                	j	47e <vprintf+0x42>
    } else if(state == '%'){
 47a:	01498d63          	beq	s3,s4,494 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 47e:	0485                	addi	s1,s1,1
 480:	fff4c903          	lbu	s2,-1(s1)
 484:	16090763          	beqz	s2,5f2 <vprintf+0x1b6>
    if(state == 0){
 488:	fe0999e3          	bnez	s3,47a <vprintf+0x3e>
      if(c == '%'){
 48c:	ff4910e3          	bne	s2,s4,46c <vprintf+0x30>
        state = '%';
 490:	89d2                	mv	s3,s4
 492:	b7f5                	j	47e <vprintf+0x42>
      if(c == 'd'){
 494:	13490463          	beq	s2,s4,5bc <vprintf+0x180>
 498:	f9d9079b          	addiw	a5,s2,-99
 49c:	0ff7f793          	zext.b	a5,a5
 4a0:	12fb6763          	bltu	s6,a5,5ce <vprintf+0x192>
 4a4:	f9d9079b          	addiw	a5,s2,-99
 4a8:	0ff7f713          	zext.b	a4,a5
 4ac:	12eb6163          	bltu	s6,a4,5ce <vprintf+0x192>
 4b0:	00271793          	slli	a5,a4,0x2
 4b4:	00000717          	auipc	a4,0x0
 4b8:	37470713          	addi	a4,a4,884 # 828 <malloc+0x13a>
 4bc:	97ba                	add	a5,a5,a4
 4be:	439c                	lw	a5,0(a5)
 4c0:	97ba                	add	a5,a5,a4
 4c2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4c4:	008b8913          	addi	s2,s7,8
 4c8:	4685                	li	a3,1
 4ca:	4629                	li	a2,10
 4cc:	000ba583          	lw	a1,0(s7)
 4d0:	8556                	mv	a0,s5
 4d2:	00000097          	auipc	ra,0x0
 4d6:	ebe080e7          	jalr	-322(ra) # 390 <printint>
 4da:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4dc:	4981                	li	s3,0
 4de:	b745                	j	47e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4e0:	008b8913          	addi	s2,s7,8
 4e4:	4681                	li	a3,0
 4e6:	4629                	li	a2,10
 4e8:	000ba583          	lw	a1,0(s7)
 4ec:	8556                	mv	a0,s5
 4ee:	00000097          	auipc	ra,0x0
 4f2:	ea2080e7          	jalr	-350(ra) # 390 <printint>
 4f6:	8bca                	mv	s7,s2
      state = 0;
 4f8:	4981                	li	s3,0
 4fa:	b751                	j	47e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 4fc:	008b8913          	addi	s2,s7,8
 500:	4681                	li	a3,0
 502:	4641                	li	a2,16
 504:	000ba583          	lw	a1,0(s7)
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	e86080e7          	jalr	-378(ra) # 390 <printint>
 512:	8bca                	mv	s7,s2
      state = 0;
 514:	4981                	li	s3,0
 516:	b7a5                	j	47e <vprintf+0x42>
 518:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 51a:	008b8c13          	addi	s8,s7,8
 51e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 522:	03000593          	li	a1,48
 526:	8556                	mv	a0,s5
 528:	00000097          	auipc	ra,0x0
 52c:	e46080e7          	jalr	-442(ra) # 36e <putc>
  putc(fd, 'x');
 530:	07800593          	li	a1,120
 534:	8556                	mv	a0,s5
 536:	00000097          	auipc	ra,0x0
 53a:	e38080e7          	jalr	-456(ra) # 36e <putc>
 53e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 540:	00000b97          	auipc	s7,0x0
 544:	340b8b93          	addi	s7,s7,832 # 880 <digits>
 548:	03c9d793          	srli	a5,s3,0x3c
 54c:	97de                	add	a5,a5,s7
 54e:	0007c583          	lbu	a1,0(a5)
 552:	8556                	mv	a0,s5
 554:	00000097          	auipc	ra,0x0
 558:	e1a080e7          	jalr	-486(ra) # 36e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 55c:	0992                	slli	s3,s3,0x4
 55e:	397d                	addiw	s2,s2,-1
 560:	fe0914e3          	bnez	s2,548 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 564:	8be2                	mv	s7,s8
      state = 0;
 566:	4981                	li	s3,0
 568:	6c02                	ld	s8,0(sp)
 56a:	bf11                	j	47e <vprintf+0x42>
        s = va_arg(ap, char*);
 56c:	008b8993          	addi	s3,s7,8
 570:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 574:	02090163          	beqz	s2,596 <vprintf+0x15a>
        while(*s != 0){
 578:	00094583          	lbu	a1,0(s2)
 57c:	c9a5                	beqz	a1,5ec <vprintf+0x1b0>
          putc(fd, *s);
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	dee080e7          	jalr	-530(ra) # 36e <putc>
          s++;
 588:	0905                	addi	s2,s2,1
        while(*s != 0){
 58a:	00094583          	lbu	a1,0(s2)
 58e:	f9e5                	bnez	a1,57e <vprintf+0x142>
        s = va_arg(ap, char*);
 590:	8bce                	mv	s7,s3
      state = 0;
 592:	4981                	li	s3,0
 594:	b5ed                	j	47e <vprintf+0x42>
          s = "(null)";
 596:	00000917          	auipc	s2,0x0
 59a:	28a90913          	addi	s2,s2,650 # 820 <malloc+0x132>
        while(*s != 0){
 59e:	02800593          	li	a1,40
 5a2:	bff1                	j	57e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5a4:	008b8913          	addi	s2,s7,8
 5a8:	000bc583          	lbu	a1,0(s7)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	dc0080e7          	jalr	-576(ra) # 36e <putc>
 5b6:	8bca                	mv	s7,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b5d1                	j	47e <vprintf+0x42>
        putc(fd, c);
 5bc:	02500593          	li	a1,37
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	dac080e7          	jalr	-596(ra) # 36e <putc>
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	bd4d                	j	47e <vprintf+0x42>
        putc(fd, '%');
 5ce:	02500593          	li	a1,37
 5d2:	8556                	mv	a0,s5
 5d4:	00000097          	auipc	ra,0x0
 5d8:	d9a080e7          	jalr	-614(ra) # 36e <putc>
        putc(fd, c);
 5dc:	85ca                	mv	a1,s2
 5de:	8556                	mv	a0,s5
 5e0:	00000097          	auipc	ra,0x0
 5e4:	d8e080e7          	jalr	-626(ra) # 36e <putc>
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	bd51                	j	47e <vprintf+0x42>
        s = va_arg(ap, char*);
 5ec:	8bce                	mv	s7,s3
      state = 0;
 5ee:	4981                	li	s3,0
 5f0:	b579                	j	47e <vprintf+0x42>
 5f2:	74e2                	ld	s1,56(sp)
 5f4:	79a2                	ld	s3,40(sp)
 5f6:	7a02                	ld	s4,32(sp)
 5f8:	6ae2                	ld	s5,24(sp)
 5fa:	6b42                	ld	s6,16(sp)
 5fc:	6ba2                	ld	s7,8(sp)
    }
  }
}
 5fe:	60a6                	ld	ra,72(sp)
 600:	6406                	ld	s0,64(sp)
 602:	7942                	ld	s2,48(sp)
 604:	6161                	addi	sp,sp,80
 606:	8082                	ret

0000000000000608 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 608:	715d                	addi	sp,sp,-80
 60a:	ec06                	sd	ra,24(sp)
 60c:	e822                	sd	s0,16(sp)
 60e:	1000                	addi	s0,sp,32
 610:	e010                	sd	a2,0(s0)
 612:	e414                	sd	a3,8(s0)
 614:	e818                	sd	a4,16(s0)
 616:	ec1c                	sd	a5,24(s0)
 618:	03043023          	sd	a6,32(s0)
 61c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 620:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 624:	8622                	mv	a2,s0
 626:	00000097          	auipc	ra,0x0
 62a:	e16080e7          	jalr	-490(ra) # 43c <vprintf>
}
 62e:	60e2                	ld	ra,24(sp)
 630:	6442                	ld	s0,16(sp)
 632:	6161                	addi	sp,sp,80
 634:	8082                	ret

0000000000000636 <printf>:

void
printf(const char *fmt, ...)
{
 636:	711d                	addi	sp,sp,-96
 638:	ec06                	sd	ra,24(sp)
 63a:	e822                	sd	s0,16(sp)
 63c:	1000                	addi	s0,sp,32
 63e:	e40c                	sd	a1,8(s0)
 640:	e810                	sd	a2,16(s0)
 642:	ec14                	sd	a3,24(s0)
 644:	f018                	sd	a4,32(s0)
 646:	f41c                	sd	a5,40(s0)
 648:	03043823          	sd	a6,48(s0)
 64c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 650:	00840613          	addi	a2,s0,8
 654:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 658:	85aa                	mv	a1,a0
 65a:	4505                	li	a0,1
 65c:	00000097          	auipc	ra,0x0
 660:	de0080e7          	jalr	-544(ra) # 43c <vprintf>
}
 664:	60e2                	ld	ra,24(sp)
 666:	6442                	ld	s0,16(sp)
 668:	6125                	addi	sp,sp,96
 66a:	8082                	ret

000000000000066c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 66c:	1141                	addi	sp,sp,-16
 66e:	e422                	sd	s0,8(sp)
 670:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 672:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 676:	00000797          	auipc	a5,0x0
 67a:	5e27b783          	ld	a5,1506(a5) # c58 <freep>
 67e:	a02d                	j	6a8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 680:	4618                	lw	a4,8(a2)
 682:	9f2d                	addw	a4,a4,a1
 684:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 688:	6398                	ld	a4,0(a5)
 68a:	6310                	ld	a2,0(a4)
 68c:	a83d                	j	6ca <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 68e:	ff852703          	lw	a4,-8(a0)
 692:	9f31                	addw	a4,a4,a2
 694:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 696:	ff053683          	ld	a3,-16(a0)
 69a:	a091                	j	6de <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 69c:	6398                	ld	a4,0(a5)
 69e:	00e7e463          	bltu	a5,a4,6a6 <free+0x3a>
 6a2:	00e6ea63          	bltu	a3,a4,6b6 <free+0x4a>
{
 6a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6a8:	fed7fae3          	bgeu	a5,a3,69c <free+0x30>
 6ac:	6398                	ld	a4,0(a5)
 6ae:	00e6e463          	bltu	a3,a4,6b6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b2:	fee7eae3          	bltu	a5,a4,6a6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6b6:	ff852583          	lw	a1,-8(a0)
 6ba:	6390                	ld	a2,0(a5)
 6bc:	02059813          	slli	a6,a1,0x20
 6c0:	01c85713          	srli	a4,a6,0x1c
 6c4:	9736                	add	a4,a4,a3
 6c6:	fae60de3          	beq	a2,a4,680 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6ce:	4790                	lw	a2,8(a5)
 6d0:	02061593          	slli	a1,a2,0x20
 6d4:	01c5d713          	srli	a4,a1,0x1c
 6d8:	973e                	add	a4,a4,a5
 6da:	fae68ae3          	beq	a3,a4,68e <free+0x22>
    p->s.ptr = bp->s.ptr;
 6de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6e0:	00000717          	auipc	a4,0x0
 6e4:	56f73c23          	sd	a5,1400(a4) # c58 <freep>
}
 6e8:	6422                	ld	s0,8(sp)
 6ea:	0141                	addi	sp,sp,16
 6ec:	8082                	ret

00000000000006ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6ee:	7139                	addi	sp,sp,-64
 6f0:	fc06                	sd	ra,56(sp)
 6f2:	f822                	sd	s0,48(sp)
 6f4:	f426                	sd	s1,40(sp)
 6f6:	ec4e                	sd	s3,24(sp)
 6f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6fa:	02051493          	slli	s1,a0,0x20
 6fe:	9081                	srli	s1,s1,0x20
 700:	04bd                	addi	s1,s1,15
 702:	8091                	srli	s1,s1,0x4
 704:	0014899b          	addiw	s3,s1,1
 708:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 70a:	00000517          	auipc	a0,0x0
 70e:	54e53503          	ld	a0,1358(a0) # c58 <freep>
 712:	c915                	beqz	a0,746 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 714:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 716:	4798                	lw	a4,8(a5)
 718:	08977e63          	bgeu	a4,s1,7b4 <malloc+0xc6>
 71c:	f04a                	sd	s2,32(sp)
 71e:	e852                	sd	s4,16(sp)
 720:	e456                	sd	s5,8(sp)
 722:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 724:	8a4e                	mv	s4,s3
 726:	0009871b          	sext.w	a4,s3
 72a:	6685                	lui	a3,0x1
 72c:	00d77363          	bgeu	a4,a3,732 <malloc+0x44>
 730:	6a05                	lui	s4,0x1
 732:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 736:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 73a:	00000917          	auipc	s2,0x0
 73e:	51e90913          	addi	s2,s2,1310 # c58 <freep>
  if(p == (char*)-1)
 742:	5afd                	li	s5,-1
 744:	a091                	j	788 <malloc+0x9a>
 746:	f04a                	sd	s2,32(sp)
 748:	e852                	sd	s4,16(sp)
 74a:	e456                	sd	s5,8(sp)
 74c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 74e:	00000797          	auipc	a5,0x0
 752:	51278793          	addi	a5,a5,1298 # c60 <base>
 756:	00000717          	auipc	a4,0x0
 75a:	50f73123          	sd	a5,1282(a4) # c58 <freep>
 75e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 760:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 764:	b7c1                	j	724 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 766:	6398                	ld	a4,0(a5)
 768:	e118                	sd	a4,0(a0)
 76a:	a08d                	j	7cc <malloc+0xde>
  hp->s.size = nu;
 76c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 770:	0541                	addi	a0,a0,16
 772:	00000097          	auipc	ra,0x0
 776:	efa080e7          	jalr	-262(ra) # 66c <free>
  return freep;
 77a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 77e:	c13d                	beqz	a0,7e4 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 780:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 782:	4798                	lw	a4,8(a5)
 784:	02977463          	bgeu	a4,s1,7ac <malloc+0xbe>
    if(p == freep)
 788:	00093703          	ld	a4,0(s2)
 78c:	853e                	mv	a0,a5
 78e:	fef719e3          	bne	a4,a5,780 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 792:	8552                	mv	a0,s4
 794:	00000097          	auipc	ra,0x0
 798:	bc2080e7          	jalr	-1086(ra) # 356 <sbrk>
  if(p == (char*)-1)
 79c:	fd5518e3          	bne	a0,s5,76c <malloc+0x7e>
        return 0;
 7a0:	4501                	li	a0,0
 7a2:	7902                	ld	s2,32(sp)
 7a4:	6a42                	ld	s4,16(sp)
 7a6:	6aa2                	ld	s5,8(sp)
 7a8:	6b02                	ld	s6,0(sp)
 7aa:	a03d                	j	7d8 <malloc+0xea>
 7ac:	7902                	ld	s2,32(sp)
 7ae:	6a42                	ld	s4,16(sp)
 7b0:	6aa2                	ld	s5,8(sp)
 7b2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7b4:	fae489e3          	beq	s1,a4,766 <malloc+0x78>
        p->s.size -= nunits;
 7b8:	4137073b          	subw	a4,a4,s3
 7bc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7be:	02071693          	slli	a3,a4,0x20
 7c2:	01c6d713          	srli	a4,a3,0x1c
 7c6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7c8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7cc:	00000717          	auipc	a4,0x0
 7d0:	48a73623          	sd	a0,1164(a4) # c58 <freep>
      return (void*)(p + 1);
 7d4:	01078513          	addi	a0,a5,16
  }
}
 7d8:	70e2                	ld	ra,56(sp)
 7da:	7442                	ld	s0,48(sp)
 7dc:	74a2                	ld	s1,40(sp)
 7de:	69e2                	ld	s3,24(sp)
 7e0:	6121                	addi	sp,sp,64
 7e2:	8082                	ret
 7e4:	7902                	ld	s2,32(sp)
 7e6:	6a42                	ld	s4,16(sp)
 7e8:	6aa2                	ld	s5,8(sp)
 7ea:	6b02                	ld	s6,0(sp)
 7ec:	b7f5                	j	7d8 <malloc+0xea>
