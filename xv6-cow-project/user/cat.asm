
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
   e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  10:	00001917          	auipc	s2,0x1
  14:	d6890913          	addi	s2,s2,-664 # d78 <buf>
  18:	20000613          	li	a2,512
  1c:	85ca                	mv	a1,s2
  1e:	854e                	mv	a0,s3
  20:	00000097          	auipc	ra,0x0
  24:	386080e7          	jalr	902(ra) # 3a6 <read>
  28:	84aa                	mv	s1,a0
  2a:	02a05963          	blez	a0,5c <cat+0x5c>
    if (write(1, buf, n) != n) {
  2e:	8626                	mv	a2,s1
  30:	85ca                	mv	a1,s2
  32:	4505                	li	a0,1
  34:	00000097          	auipc	ra,0x0
  38:	37a080e7          	jalr	890(ra) # 3ae <write>
  3c:	fc950ee3          	beq	a0,s1,18 <cat+0x18>
      fprintf(2, "cat: write error\n");
  40:	00001597          	auipc	a1,0x1
  44:	87058593          	addi	a1,a1,-1936 # 8b0 <malloc+0x102>
  48:	4509                	li	a0,2
  4a:	00000097          	auipc	ra,0x0
  4e:	67e080e7          	jalr	1662(ra) # 6c8 <fprintf>
      exit(1);
  52:	4505                	li	a0,1
  54:	00000097          	auipc	ra,0x0
  58:	33a080e7          	jalr	826(ra) # 38e <exit>
    }
  }
  if(n < 0){
  5c:	00054963          	bltz	a0,6e <cat+0x6e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
  60:	70a2                	ld	ra,40(sp)
  62:	7402                	ld	s0,32(sp)
  64:	64e2                	ld	s1,24(sp)
  66:	6942                	ld	s2,16(sp)
  68:	69a2                	ld	s3,8(sp)
  6a:	6145                	addi	sp,sp,48
  6c:	8082                	ret
    fprintf(2, "cat: read error\n");
  6e:	00001597          	auipc	a1,0x1
  72:	85a58593          	addi	a1,a1,-1958 # 8c8 <malloc+0x11a>
  76:	4509                	li	a0,2
  78:	00000097          	auipc	ra,0x0
  7c:	650080e7          	jalr	1616(ra) # 6c8 <fprintf>
    exit(1);
  80:	4505                	li	a0,1
  82:	00000097          	auipc	ra,0x0
  86:	30c080e7          	jalr	780(ra) # 38e <exit>

000000000000008a <main>:

int
main(int argc, char *argv[])
{
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  92:	4785                	li	a5,1
  94:	04a7da63          	bge	a5,a0,e8 <main+0x5e>
  98:	ec26                	sd	s1,24(sp)
  9a:	e84a                	sd	s2,16(sp)
  9c:	e44e                	sd	s3,8(sp)
  9e:	00858913          	addi	s2,a1,8
  a2:	ffe5099b          	addiw	s3,a0,-2
  a6:	02099793          	slli	a5,s3,0x20
  aa:	01d7d993          	srli	s3,a5,0x1d
  ae:	05c1                	addi	a1,a1,16
  b0:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
  b2:	4581                	li	a1,0
  b4:	00093503          	ld	a0,0(s2)
  b8:	00000097          	auipc	ra,0x0
  bc:	316080e7          	jalr	790(ra) # 3ce <open>
  c0:	84aa                	mv	s1,a0
  c2:	04054063          	bltz	a0,102 <main+0x78>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
  c6:	00000097          	auipc	ra,0x0
  ca:	f3a080e7          	jalr	-198(ra) # 0 <cat>
    close(fd);
  ce:	8526                	mv	a0,s1
  d0:	00000097          	auipc	ra,0x0
  d4:	2e6080e7          	jalr	742(ra) # 3b6 <close>
  for(i = 1; i < argc; i++){
  d8:	0921                	addi	s2,s2,8
  da:	fd391ce3          	bne	s2,s3,b2 <main+0x28>
  }
  exit(0);
  de:	4501                	li	a0,0
  e0:	00000097          	auipc	ra,0x0
  e4:	2ae080e7          	jalr	686(ra) # 38e <exit>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
    cat(0);
  ee:	4501                	li	a0,0
  f0:	00000097          	auipc	ra,0x0
  f4:	f10080e7          	jalr	-240(ra) # 0 <cat>
    exit(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	294080e7          	jalr	660(ra) # 38e <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
 102:	00093603          	ld	a2,0(s2)
 106:	00000597          	auipc	a1,0x0
 10a:	7da58593          	addi	a1,a1,2010 # 8e0 <malloc+0x132>
 10e:	4509                	li	a0,2
 110:	00000097          	auipc	ra,0x0
 114:	5b8080e7          	jalr	1464(ra) # 6c8 <fprintf>
      exit(1);
 118:	4505                	li	a0,1
 11a:	00000097          	auipc	ra,0x0
 11e:	274080e7          	jalr	628(ra) # 38e <exit>

0000000000000122 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 122:	1141                	addi	sp,sp,-16
 124:	e422                	sd	s0,8(sp)
 126:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 128:	87aa                	mv	a5,a0
 12a:	0585                	addi	a1,a1,1
 12c:	0785                	addi	a5,a5,1
 12e:	fff5c703          	lbu	a4,-1(a1)
 132:	fee78fa3          	sb	a4,-1(a5)
 136:	fb75                	bnez	a4,12a <strcpy+0x8>
    ;
  return os;
}
 138:	6422                	ld	s0,8(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e422                	sd	s0,8(sp)
 142:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 144:	00054783          	lbu	a5,0(a0)
 148:	cb91                	beqz	a5,15c <strcmp+0x1e>
 14a:	0005c703          	lbu	a4,0(a1)
 14e:	00f71763          	bne	a4,a5,15c <strcmp+0x1e>
    p++, q++;
 152:	0505                	addi	a0,a0,1
 154:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 156:	00054783          	lbu	a5,0(a0)
 15a:	fbe5                	bnez	a5,14a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 15c:	0005c503          	lbu	a0,0(a1)
}
 160:	40a7853b          	subw	a0,a5,a0
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret

000000000000016a <strlen>:

uint
strlen(const char *s)
{
 16a:	1141                	addi	sp,sp,-16
 16c:	e422                	sd	s0,8(sp)
 16e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 170:	00054783          	lbu	a5,0(a0)
 174:	cf91                	beqz	a5,190 <strlen+0x26>
 176:	0505                	addi	a0,a0,1
 178:	87aa                	mv	a5,a0
 17a:	86be                	mv	a3,a5
 17c:	0785                	addi	a5,a5,1
 17e:	fff7c703          	lbu	a4,-1(a5)
 182:	ff65                	bnez	a4,17a <strlen+0x10>
 184:	40a6853b          	subw	a0,a3,a0
 188:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret
  for(n = 0; s[n]; n++)
 190:	4501                	li	a0,0
 192:	bfe5                	j	18a <strlen+0x20>

0000000000000194 <memset>:

void*
memset(void *dst, int c, uint n)
{
 194:	1141                	addi	sp,sp,-16
 196:	e422                	sd	s0,8(sp)
 198:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19a:	ca19                	beqz	a2,1b0 <memset+0x1c>
 19c:	87aa                	mv	a5,a0
 19e:	1602                	slli	a2,a2,0x20
 1a0:	9201                	srli	a2,a2,0x20
 1a2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1aa:	0785                	addi	a5,a5,1
 1ac:	fee79de3          	bne	a5,a4,1a6 <memset+0x12>
  }
  return dst;
}
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strchr>:

char*
strchr(const char *s, char c)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cb99                	beqz	a5,1d6 <strchr+0x20>
    if(*s == c)
 1c2:	00f58763          	beq	a1,a5,1d0 <strchr+0x1a>
  for(; *s; s++)
 1c6:	0505                	addi	a0,a0,1
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	fbfd                	bnez	a5,1c2 <strchr+0xc>
      return (char*)s;
  return 0;
 1ce:	4501                	li	a0,0
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
  return 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <strchr+0x1a>

00000000000001da <gets>:

char*
gets(char *buf, int max)
{
 1da:	711d                	addi	sp,sp,-96
 1dc:	ec86                	sd	ra,88(sp)
 1de:	e8a2                	sd	s0,80(sp)
 1e0:	e4a6                	sd	s1,72(sp)
 1e2:	e0ca                	sd	s2,64(sp)
 1e4:	fc4e                	sd	s3,56(sp)
 1e6:	f852                	sd	s4,48(sp)
 1e8:	f456                	sd	s5,40(sp)
 1ea:	f05a                	sd	s6,32(sp)
 1ec:	ec5e                	sd	s7,24(sp)
 1ee:	1080                	addi	s0,sp,96
 1f0:	8baa                	mv	s7,a0
 1f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f4:	892a                	mv	s2,a0
 1f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1f8:	4aa9                	li	s5,10
 1fa:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1fc:	89a6                	mv	s3,s1
 1fe:	2485                	addiw	s1,s1,1
 200:	0344d863          	bge	s1,s4,230 <gets+0x56>
    cc = read(0, &c, 1);
 204:	4605                	li	a2,1
 206:	faf40593          	addi	a1,s0,-81
 20a:	4501                	li	a0,0
 20c:	00000097          	auipc	ra,0x0
 210:	19a080e7          	jalr	410(ra) # 3a6 <read>
    if(cc < 1)
 214:	00a05e63          	blez	a0,230 <gets+0x56>
    buf[i++] = c;
 218:	faf44783          	lbu	a5,-81(s0)
 21c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 220:	01578763          	beq	a5,s5,22e <gets+0x54>
 224:	0905                	addi	s2,s2,1
 226:	fd679be3          	bne	a5,s6,1fc <gets+0x22>
    buf[i++] = c;
 22a:	89a6                	mv	s3,s1
 22c:	a011                	j	230 <gets+0x56>
 22e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 230:	99de                	add	s3,s3,s7
 232:	00098023          	sb	zero,0(s3)
  return buf;
}
 236:	855e                	mv	a0,s7
 238:	60e6                	ld	ra,88(sp)
 23a:	6446                	ld	s0,80(sp)
 23c:	64a6                	ld	s1,72(sp)
 23e:	6906                	ld	s2,64(sp)
 240:	79e2                	ld	s3,56(sp)
 242:	7a42                	ld	s4,48(sp)
 244:	7aa2                	ld	s5,40(sp)
 246:	7b02                	ld	s6,32(sp)
 248:	6be2                	ld	s7,24(sp)
 24a:	6125                	addi	sp,sp,96
 24c:	8082                	ret

000000000000024e <stat>:

int
stat(const char *n, struct stat *st)
{
 24e:	1101                	addi	sp,sp,-32
 250:	ec06                	sd	ra,24(sp)
 252:	e822                	sd	s0,16(sp)
 254:	e04a                	sd	s2,0(sp)
 256:	1000                	addi	s0,sp,32
 258:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25a:	4581                	li	a1,0
 25c:	00000097          	auipc	ra,0x0
 260:	172080e7          	jalr	370(ra) # 3ce <open>
  if(fd < 0)
 264:	02054663          	bltz	a0,290 <stat+0x42>
 268:	e426                	sd	s1,8(sp)
 26a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 26c:	85ca                	mv	a1,s2
 26e:	00000097          	auipc	ra,0x0
 272:	178080e7          	jalr	376(ra) # 3e6 <fstat>
 276:	892a                	mv	s2,a0
  close(fd);
 278:	8526                	mv	a0,s1
 27a:	00000097          	auipc	ra,0x0
 27e:	13c080e7          	jalr	316(ra) # 3b6 <close>
  return r;
 282:	64a2                	ld	s1,8(sp)
}
 284:	854a                	mv	a0,s2
 286:	60e2                	ld	ra,24(sp)
 288:	6442                	ld	s0,16(sp)
 28a:	6902                	ld	s2,0(sp)
 28c:	6105                	addi	sp,sp,32
 28e:	8082                	ret
    return -1;
 290:	597d                	li	s2,-1
 292:	bfcd                	j	284 <stat+0x36>

0000000000000294 <atoi>:

int
atoi(const char *s)
{
 294:	1141                	addi	sp,sp,-16
 296:	e422                	sd	s0,8(sp)
 298:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 29a:	00054683          	lbu	a3,0(a0)
 29e:	fd06879b          	addiw	a5,a3,-48
 2a2:	0ff7f793          	zext.b	a5,a5
 2a6:	4625                	li	a2,9
 2a8:	02f66863          	bltu	a2,a5,2d8 <atoi+0x44>
 2ac:	872a                	mv	a4,a0
  n = 0;
 2ae:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2b0:	0705                	addi	a4,a4,1
 2b2:	0025179b          	slliw	a5,a0,0x2
 2b6:	9fa9                	addw	a5,a5,a0
 2b8:	0017979b          	slliw	a5,a5,0x1
 2bc:	9fb5                	addw	a5,a5,a3
 2be:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2c2:	00074683          	lbu	a3,0(a4)
 2c6:	fd06879b          	addiw	a5,a3,-48
 2ca:	0ff7f793          	zext.b	a5,a5
 2ce:	fef671e3          	bgeu	a2,a5,2b0 <atoi+0x1c>
  return n;
}
 2d2:	6422                	ld	s0,8(sp)
 2d4:	0141                	addi	sp,sp,16
 2d6:	8082                	ret
  n = 0;
 2d8:	4501                	li	a0,0
 2da:	bfe5                	j	2d2 <atoi+0x3e>

00000000000002dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2dc:	1141                	addi	sp,sp,-16
 2de:	e422                	sd	s0,8(sp)
 2e0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e2:	02b57463          	bgeu	a0,a1,30a <memmove+0x2e>
    while(n-- > 0)
 2e6:	00c05f63          	blez	a2,304 <memmove+0x28>
 2ea:	1602                	slli	a2,a2,0x20
 2ec:	9201                	srli	a2,a2,0x20
 2ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f4:	0585                	addi	a1,a1,1
 2f6:	0705                	addi	a4,a4,1
 2f8:	fff5c683          	lbu	a3,-1(a1)
 2fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 300:	fef71ae3          	bne	a4,a5,2f4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 304:	6422                	ld	s0,8(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret
    dst += n;
 30a:	00c50733          	add	a4,a0,a2
    src += n;
 30e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 310:	fec05ae3          	blez	a2,304 <memmove+0x28>
 314:	fff6079b          	addiw	a5,a2,-1
 318:	1782                	slli	a5,a5,0x20
 31a:	9381                	srli	a5,a5,0x20
 31c:	fff7c793          	not	a5,a5
 320:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 322:	15fd                	addi	a1,a1,-1
 324:	177d                	addi	a4,a4,-1
 326:	0005c683          	lbu	a3,0(a1)
 32a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 32e:	fee79ae3          	bne	a5,a4,322 <memmove+0x46>
 332:	bfc9                	j	304 <memmove+0x28>

0000000000000334 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33a:	ca05                	beqz	a2,36a <memcmp+0x36>
 33c:	fff6069b          	addiw	a3,a2,-1
 340:	1682                	slli	a3,a3,0x20
 342:	9281                	srli	a3,a3,0x20
 344:	0685                	addi	a3,a3,1
 346:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 348:	00054783          	lbu	a5,0(a0)
 34c:	0005c703          	lbu	a4,0(a1)
 350:	00e79863          	bne	a5,a4,360 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 354:	0505                	addi	a0,a0,1
    p2++;
 356:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 358:	fed518e3          	bne	a0,a3,348 <memcmp+0x14>
  }
  return 0;
 35c:	4501                	li	a0,0
 35e:	a019                	j	364 <memcmp+0x30>
      return *p1 - *p2;
 360:	40e7853b          	subw	a0,a5,a4
}
 364:	6422                	ld	s0,8(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret
  return 0;
 36a:	4501                	li	a0,0
 36c:	bfe5                	j	364 <memcmp+0x30>

000000000000036e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 36e:	1141                	addi	sp,sp,-16
 370:	e406                	sd	ra,8(sp)
 372:	e022                	sd	s0,0(sp)
 374:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 376:	00000097          	auipc	ra,0x0
 37a:	f66080e7          	jalr	-154(ra) # 2dc <memmove>
}
 37e:	60a2                	ld	ra,8(sp)
 380:	6402                	ld	s0,0(sp)
 382:	0141                	addi	sp,sp,16
 384:	8082                	ret

0000000000000386 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 386:	4885                	li	a7,1
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <exit>:
.global exit
exit:
 li a7, SYS_exit
 38e:	4889                	li	a7,2
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <wait>:
.global wait
wait:
 li a7, SYS_wait
 396:	488d                	li	a7,3
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39e:	4891                	li	a7,4
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <read>:
.global read
read:
 li a7, SYS_read
 3a6:	4895                	li	a7,5
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <write>:
.global write
write:
 li a7, SYS_write
 3ae:	48c1                	li	a7,16
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <close>:
.global close
close:
 li a7, SYS_close
 3b6:	48d5                	li	a7,21
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <kill>:
.global kill
kill:
 li a7, SYS_kill
 3be:	4899                	li	a7,6
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c6:	489d                	li	a7,7
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <open>:
.global open
open:
 li a7, SYS_open
 3ce:	48bd                	li	a7,15
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d6:	48c5                	li	a7,17
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3de:	48c9                	li	a7,18
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e6:	48a1                	li	a7,8
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <link>:
.global link
link:
 li a7, SYS_link
 3ee:	48cd                	li	a7,19
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f6:	48d1                	li	a7,20
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fe:	48a5                	li	a7,9
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <dup>:
.global dup
dup:
 li a7, SYS_dup
 406:	48a9                	li	a7,10
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40e:	48ad                	li	a7,11
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 416:	48b1                	li	a7,12
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 41e:	48b5                	li	a7,13
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 426:	48b9                	li	a7,14
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 42e:	1101                	addi	sp,sp,-32
 430:	ec06                	sd	ra,24(sp)
 432:	e822                	sd	s0,16(sp)
 434:	1000                	addi	s0,sp,32
 436:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 43a:	4605                	li	a2,1
 43c:	fef40593          	addi	a1,s0,-17
 440:	00000097          	auipc	ra,0x0
 444:	f6e080e7          	jalr	-146(ra) # 3ae <write>
}
 448:	60e2                	ld	ra,24(sp)
 44a:	6442                	ld	s0,16(sp)
 44c:	6105                	addi	sp,sp,32
 44e:	8082                	ret

0000000000000450 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 450:	7139                	addi	sp,sp,-64
 452:	fc06                	sd	ra,56(sp)
 454:	f822                	sd	s0,48(sp)
 456:	f426                	sd	s1,40(sp)
 458:	0080                	addi	s0,sp,64
 45a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 45c:	c299                	beqz	a3,462 <printint+0x12>
 45e:	0805cb63          	bltz	a1,4f4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 462:	2581                	sext.w	a1,a1
  neg = 0;
 464:	4881                	li	a7,0
 466:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 46a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 46c:	2601                	sext.w	a2,a2
 46e:	00000517          	auipc	a0,0x0
 472:	4ea50513          	addi	a0,a0,1258 # 958 <digits>
 476:	883a                	mv	a6,a4
 478:	2705                	addiw	a4,a4,1
 47a:	02c5f7bb          	remuw	a5,a1,a2
 47e:	1782                	slli	a5,a5,0x20
 480:	9381                	srli	a5,a5,0x20
 482:	97aa                	add	a5,a5,a0
 484:	0007c783          	lbu	a5,0(a5)
 488:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 48c:	0005879b          	sext.w	a5,a1
 490:	02c5d5bb          	divuw	a1,a1,a2
 494:	0685                	addi	a3,a3,1
 496:	fec7f0e3          	bgeu	a5,a2,476 <printint+0x26>
  if(neg)
 49a:	00088c63          	beqz	a7,4b2 <printint+0x62>
    buf[i++] = '-';
 49e:	fd070793          	addi	a5,a4,-48
 4a2:	00878733          	add	a4,a5,s0
 4a6:	02d00793          	li	a5,45
 4aa:	fef70823          	sb	a5,-16(a4)
 4ae:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4b2:	02e05c63          	blez	a4,4ea <printint+0x9a>
 4b6:	f04a                	sd	s2,32(sp)
 4b8:	ec4e                	sd	s3,24(sp)
 4ba:	fc040793          	addi	a5,s0,-64
 4be:	00e78933          	add	s2,a5,a4
 4c2:	fff78993          	addi	s3,a5,-1
 4c6:	99ba                	add	s3,s3,a4
 4c8:	377d                	addiw	a4,a4,-1
 4ca:	1702                	slli	a4,a4,0x20
 4cc:	9301                	srli	a4,a4,0x20
 4ce:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4d2:	fff94583          	lbu	a1,-1(s2)
 4d6:	8526                	mv	a0,s1
 4d8:	00000097          	auipc	ra,0x0
 4dc:	f56080e7          	jalr	-170(ra) # 42e <putc>
  while(--i >= 0)
 4e0:	197d                	addi	s2,s2,-1
 4e2:	ff3918e3          	bne	s2,s3,4d2 <printint+0x82>
 4e6:	7902                	ld	s2,32(sp)
 4e8:	69e2                	ld	s3,24(sp)
}
 4ea:	70e2                	ld	ra,56(sp)
 4ec:	7442                	ld	s0,48(sp)
 4ee:	74a2                	ld	s1,40(sp)
 4f0:	6121                	addi	sp,sp,64
 4f2:	8082                	ret
    x = -xx;
 4f4:	40b005bb          	negw	a1,a1
    neg = 1;
 4f8:	4885                	li	a7,1
    x = -xx;
 4fa:	b7b5                	j	466 <printint+0x16>

00000000000004fc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fc:	715d                	addi	sp,sp,-80
 4fe:	e486                	sd	ra,72(sp)
 500:	e0a2                	sd	s0,64(sp)
 502:	f84a                	sd	s2,48(sp)
 504:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 506:	0005c903          	lbu	s2,0(a1)
 50a:	1a090a63          	beqz	s2,6be <vprintf+0x1c2>
 50e:	fc26                	sd	s1,56(sp)
 510:	f44e                	sd	s3,40(sp)
 512:	f052                	sd	s4,32(sp)
 514:	ec56                	sd	s5,24(sp)
 516:	e85a                	sd	s6,16(sp)
 518:	e45e                	sd	s7,8(sp)
 51a:	8aaa                	mv	s5,a0
 51c:	8bb2                	mv	s7,a2
 51e:	00158493          	addi	s1,a1,1
  state = 0;
 522:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 524:	02500a13          	li	s4,37
 528:	4b55                	li	s6,21
 52a:	a839                	j	548 <vprintf+0x4c>
        putc(fd, c);
 52c:	85ca                	mv	a1,s2
 52e:	8556                	mv	a0,s5
 530:	00000097          	auipc	ra,0x0
 534:	efe080e7          	jalr	-258(ra) # 42e <putc>
 538:	a019                	j	53e <vprintf+0x42>
    } else if(state == '%'){
 53a:	01498d63          	beq	s3,s4,554 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 53e:	0485                	addi	s1,s1,1
 540:	fff4c903          	lbu	s2,-1(s1)
 544:	16090763          	beqz	s2,6b2 <vprintf+0x1b6>
    if(state == 0){
 548:	fe0999e3          	bnez	s3,53a <vprintf+0x3e>
      if(c == '%'){
 54c:	ff4910e3          	bne	s2,s4,52c <vprintf+0x30>
        state = '%';
 550:	89d2                	mv	s3,s4
 552:	b7f5                	j	53e <vprintf+0x42>
      if(c == 'd'){
 554:	13490463          	beq	s2,s4,67c <vprintf+0x180>
 558:	f9d9079b          	addiw	a5,s2,-99
 55c:	0ff7f793          	zext.b	a5,a5
 560:	12fb6763          	bltu	s6,a5,68e <vprintf+0x192>
 564:	f9d9079b          	addiw	a5,s2,-99
 568:	0ff7f713          	zext.b	a4,a5
 56c:	12eb6163          	bltu	s6,a4,68e <vprintf+0x192>
 570:	00271793          	slli	a5,a4,0x2
 574:	00000717          	auipc	a4,0x0
 578:	38c70713          	addi	a4,a4,908 # 900 <malloc+0x152>
 57c:	97ba                	add	a5,a5,a4
 57e:	439c                	lw	a5,0(a5)
 580:	97ba                	add	a5,a5,a4
 582:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 584:	008b8913          	addi	s2,s7,8
 588:	4685                	li	a3,1
 58a:	4629                	li	a2,10
 58c:	000ba583          	lw	a1,0(s7)
 590:	8556                	mv	a0,s5
 592:	00000097          	auipc	ra,0x0
 596:	ebe080e7          	jalr	-322(ra) # 450 <printint>
 59a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b745                	j	53e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a0:	008b8913          	addi	s2,s7,8
 5a4:	4681                	li	a3,0
 5a6:	4629                	li	a2,10
 5a8:	000ba583          	lw	a1,0(s7)
 5ac:	8556                	mv	a0,s5
 5ae:	00000097          	auipc	ra,0x0
 5b2:	ea2080e7          	jalr	-350(ra) # 450 <printint>
 5b6:	8bca                	mv	s7,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b751                	j	53e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4641                	li	a2,16
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	8556                	mv	a0,s5
 5ca:	00000097          	auipc	ra,0x0
 5ce:	e86080e7          	jalr	-378(ra) # 450 <printint>
 5d2:	8bca                	mv	s7,s2
      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b7a5                	j	53e <vprintf+0x42>
 5d8:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5da:	008b8c13          	addi	s8,s7,8
 5de:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e2:	03000593          	li	a1,48
 5e6:	8556                	mv	a0,s5
 5e8:	00000097          	auipc	ra,0x0
 5ec:	e46080e7          	jalr	-442(ra) # 42e <putc>
  putc(fd, 'x');
 5f0:	07800593          	li	a1,120
 5f4:	8556                	mv	a0,s5
 5f6:	00000097          	auipc	ra,0x0
 5fa:	e38080e7          	jalr	-456(ra) # 42e <putc>
 5fe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 600:	00000b97          	auipc	s7,0x0
 604:	358b8b93          	addi	s7,s7,856 # 958 <digits>
 608:	03c9d793          	srli	a5,s3,0x3c
 60c:	97de                	add	a5,a5,s7
 60e:	0007c583          	lbu	a1,0(a5)
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	e1a080e7          	jalr	-486(ra) # 42e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 61c:	0992                	slli	s3,s3,0x4
 61e:	397d                	addiw	s2,s2,-1
 620:	fe0914e3          	bnez	s2,608 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 624:	8be2                	mv	s7,s8
      state = 0;
 626:	4981                	li	s3,0
 628:	6c02                	ld	s8,0(sp)
 62a:	bf11                	j	53e <vprintf+0x42>
        s = va_arg(ap, char*);
 62c:	008b8993          	addi	s3,s7,8
 630:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 634:	02090163          	beqz	s2,656 <vprintf+0x15a>
        while(*s != 0){
 638:	00094583          	lbu	a1,0(s2)
 63c:	c9a5                	beqz	a1,6ac <vprintf+0x1b0>
          putc(fd, *s);
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	dee080e7          	jalr	-530(ra) # 42e <putc>
          s++;
 648:	0905                	addi	s2,s2,1
        while(*s != 0){
 64a:	00094583          	lbu	a1,0(s2)
 64e:	f9e5                	bnez	a1,63e <vprintf+0x142>
        s = va_arg(ap, char*);
 650:	8bce                	mv	s7,s3
      state = 0;
 652:	4981                	li	s3,0
 654:	b5ed                	j	53e <vprintf+0x42>
          s = "(null)";
 656:	00000917          	auipc	s2,0x0
 65a:	2a290913          	addi	s2,s2,674 # 8f8 <malloc+0x14a>
        while(*s != 0){
 65e:	02800593          	li	a1,40
 662:	bff1                	j	63e <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 664:	008b8913          	addi	s2,s7,8
 668:	000bc583          	lbu	a1,0(s7)
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	dc0080e7          	jalr	-576(ra) # 42e <putc>
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	b5d1                	j	53e <vprintf+0x42>
        putc(fd, c);
 67c:	02500593          	li	a1,37
 680:	8556                	mv	a0,s5
 682:	00000097          	auipc	ra,0x0
 686:	dac080e7          	jalr	-596(ra) # 42e <putc>
      state = 0;
 68a:	4981                	li	s3,0
 68c:	bd4d                	j	53e <vprintf+0x42>
        putc(fd, '%');
 68e:	02500593          	li	a1,37
 692:	8556                	mv	a0,s5
 694:	00000097          	auipc	ra,0x0
 698:	d9a080e7          	jalr	-614(ra) # 42e <putc>
        putc(fd, c);
 69c:	85ca                	mv	a1,s2
 69e:	8556                	mv	a0,s5
 6a0:	00000097          	auipc	ra,0x0
 6a4:	d8e080e7          	jalr	-626(ra) # 42e <putc>
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	bd51                	j	53e <vprintf+0x42>
        s = va_arg(ap, char*);
 6ac:	8bce                	mv	s7,s3
      state = 0;
 6ae:	4981                	li	s3,0
 6b0:	b579                	j	53e <vprintf+0x42>
 6b2:	74e2                	ld	s1,56(sp)
 6b4:	79a2                	ld	s3,40(sp)
 6b6:	7a02                	ld	s4,32(sp)
 6b8:	6ae2                	ld	s5,24(sp)
 6ba:	6b42                	ld	s6,16(sp)
 6bc:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6be:	60a6                	ld	ra,72(sp)
 6c0:	6406                	ld	s0,64(sp)
 6c2:	7942                	ld	s2,48(sp)
 6c4:	6161                	addi	sp,sp,80
 6c6:	8082                	ret

00000000000006c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c8:	715d                	addi	sp,sp,-80
 6ca:	ec06                	sd	ra,24(sp)
 6cc:	e822                	sd	s0,16(sp)
 6ce:	1000                	addi	s0,sp,32
 6d0:	e010                	sd	a2,0(s0)
 6d2:	e414                	sd	a3,8(s0)
 6d4:	e818                	sd	a4,16(s0)
 6d6:	ec1c                	sd	a5,24(s0)
 6d8:	03043023          	sd	a6,32(s0)
 6dc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6e0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e4:	8622                	mv	a2,s0
 6e6:	00000097          	auipc	ra,0x0
 6ea:	e16080e7          	jalr	-490(ra) # 4fc <vprintf>
}
 6ee:	60e2                	ld	ra,24(sp)
 6f0:	6442                	ld	s0,16(sp)
 6f2:	6161                	addi	sp,sp,80
 6f4:	8082                	ret

00000000000006f6 <printf>:

void
printf(const char *fmt, ...)
{
 6f6:	711d                	addi	sp,sp,-96
 6f8:	ec06                	sd	ra,24(sp)
 6fa:	e822                	sd	s0,16(sp)
 6fc:	1000                	addi	s0,sp,32
 6fe:	e40c                	sd	a1,8(s0)
 700:	e810                	sd	a2,16(s0)
 702:	ec14                	sd	a3,24(s0)
 704:	f018                	sd	a4,32(s0)
 706:	f41c                	sd	a5,40(s0)
 708:	03043823          	sd	a6,48(s0)
 70c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 710:	00840613          	addi	a2,s0,8
 714:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 718:	85aa                	mv	a1,a0
 71a:	4505                	li	a0,1
 71c:	00000097          	auipc	ra,0x0
 720:	de0080e7          	jalr	-544(ra) # 4fc <vprintf>
}
 724:	60e2                	ld	ra,24(sp)
 726:	6442                	ld	s0,16(sp)
 728:	6125                	addi	sp,sp,96
 72a:	8082                	ret

000000000000072c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72c:	1141                	addi	sp,sp,-16
 72e:	e422                	sd	s0,8(sp)
 730:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 732:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 736:	00000797          	auipc	a5,0x0
 73a:	63a7b783          	ld	a5,1594(a5) # d70 <freep>
 73e:	a02d                	j	768 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 740:	4618                	lw	a4,8(a2)
 742:	9f2d                	addw	a4,a4,a1
 744:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 748:	6398                	ld	a4,0(a5)
 74a:	6310                	ld	a2,0(a4)
 74c:	a83d                	j	78a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 74e:	ff852703          	lw	a4,-8(a0)
 752:	9f31                	addw	a4,a4,a2
 754:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 756:	ff053683          	ld	a3,-16(a0)
 75a:	a091                	j	79e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75c:	6398                	ld	a4,0(a5)
 75e:	00e7e463          	bltu	a5,a4,766 <free+0x3a>
 762:	00e6ea63          	bltu	a3,a4,776 <free+0x4a>
{
 766:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	fed7fae3          	bgeu	a5,a3,75c <free+0x30>
 76c:	6398                	ld	a4,0(a5)
 76e:	00e6e463          	bltu	a3,a4,776 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 772:	fee7eae3          	bltu	a5,a4,766 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 776:	ff852583          	lw	a1,-8(a0)
 77a:	6390                	ld	a2,0(a5)
 77c:	02059813          	slli	a6,a1,0x20
 780:	01c85713          	srli	a4,a6,0x1c
 784:	9736                	add	a4,a4,a3
 786:	fae60de3          	beq	a2,a4,740 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 78a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 78e:	4790                	lw	a2,8(a5)
 790:	02061593          	slli	a1,a2,0x20
 794:	01c5d713          	srli	a4,a1,0x1c
 798:	973e                	add	a4,a4,a5
 79a:	fae68ae3          	beq	a3,a4,74e <free+0x22>
    p->s.ptr = bp->s.ptr;
 79e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a0:	00000717          	auipc	a4,0x0
 7a4:	5cf73823          	sd	a5,1488(a4) # d70 <freep>
}
 7a8:	6422                	ld	s0,8(sp)
 7aa:	0141                	addi	sp,sp,16
 7ac:	8082                	ret

00000000000007ae <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ae:	7139                	addi	sp,sp,-64
 7b0:	fc06                	sd	ra,56(sp)
 7b2:	f822                	sd	s0,48(sp)
 7b4:	f426                	sd	s1,40(sp)
 7b6:	ec4e                	sd	s3,24(sp)
 7b8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7ba:	02051493          	slli	s1,a0,0x20
 7be:	9081                	srli	s1,s1,0x20
 7c0:	04bd                	addi	s1,s1,15
 7c2:	8091                	srli	s1,s1,0x4
 7c4:	0014899b          	addiw	s3,s1,1
 7c8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7ca:	00000517          	auipc	a0,0x0
 7ce:	5a653503          	ld	a0,1446(a0) # d70 <freep>
 7d2:	c915                	beqz	a0,806 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d6:	4798                	lw	a4,8(a5)
 7d8:	08977e63          	bgeu	a4,s1,874 <malloc+0xc6>
 7dc:	f04a                	sd	s2,32(sp)
 7de:	e852                	sd	s4,16(sp)
 7e0:	e456                	sd	s5,8(sp)
 7e2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7e4:	8a4e                	mv	s4,s3
 7e6:	0009871b          	sext.w	a4,s3
 7ea:	6685                	lui	a3,0x1
 7ec:	00d77363          	bgeu	a4,a3,7f2 <malloc+0x44>
 7f0:	6a05                	lui	s4,0x1
 7f2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7f6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7fa:	00000917          	auipc	s2,0x0
 7fe:	57690913          	addi	s2,s2,1398 # d70 <freep>
  if(p == (char*)-1)
 802:	5afd                	li	s5,-1
 804:	a091                	j	848 <malloc+0x9a>
 806:	f04a                	sd	s2,32(sp)
 808:	e852                	sd	s4,16(sp)
 80a:	e456                	sd	s5,8(sp)
 80c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 80e:	00000797          	auipc	a5,0x0
 812:	76a78793          	addi	a5,a5,1898 # f78 <base>
 816:	00000717          	auipc	a4,0x0
 81a:	54f73d23          	sd	a5,1370(a4) # d70 <freep>
 81e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 820:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 824:	b7c1                	j	7e4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 826:	6398                	ld	a4,0(a5)
 828:	e118                	sd	a4,0(a0)
 82a:	a08d                	j	88c <malloc+0xde>
  hp->s.size = nu;
 82c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 830:	0541                	addi	a0,a0,16
 832:	00000097          	auipc	ra,0x0
 836:	efa080e7          	jalr	-262(ra) # 72c <free>
  return freep;
 83a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 83e:	c13d                	beqz	a0,8a4 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 840:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 842:	4798                	lw	a4,8(a5)
 844:	02977463          	bgeu	a4,s1,86c <malloc+0xbe>
    if(p == freep)
 848:	00093703          	ld	a4,0(s2)
 84c:	853e                	mv	a0,a5
 84e:	fef719e3          	bne	a4,a5,840 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 852:	8552                	mv	a0,s4
 854:	00000097          	auipc	ra,0x0
 858:	bc2080e7          	jalr	-1086(ra) # 416 <sbrk>
  if(p == (char*)-1)
 85c:	fd5518e3          	bne	a0,s5,82c <malloc+0x7e>
        return 0;
 860:	4501                	li	a0,0
 862:	7902                	ld	s2,32(sp)
 864:	6a42                	ld	s4,16(sp)
 866:	6aa2                	ld	s5,8(sp)
 868:	6b02                	ld	s6,0(sp)
 86a:	a03d                	j	898 <malloc+0xea>
 86c:	7902                	ld	s2,32(sp)
 86e:	6a42                	ld	s4,16(sp)
 870:	6aa2                	ld	s5,8(sp)
 872:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 874:	fae489e3          	beq	s1,a4,826 <malloc+0x78>
        p->s.size -= nunits;
 878:	4137073b          	subw	a4,a4,s3
 87c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 87e:	02071693          	slli	a3,a4,0x20
 882:	01c6d713          	srli	a4,a3,0x1c
 886:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 888:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 88c:	00000717          	auipc	a4,0x0
 890:	4ea73223          	sd	a0,1252(a4) # d70 <freep>
      return (void*)(p + 1);
 894:	01078513          	addi	a0,a5,16
  }
}
 898:	70e2                	ld	ra,56(sp)
 89a:	7442                	ld	s0,48(sp)
 89c:	74a2                	ld	s1,40(sp)
 89e:	69e2                	ld	s3,24(sp)
 8a0:	6121                	addi	sp,sp,64
 8a2:	8082                	ret
 8a4:	7902                	ld	s2,32(sp)
 8a6:	6a42                	ld	s4,16(sp)
 8a8:	6aa2                	ld	s5,8(sp)
 8aa:	6b02                	ld	s6,0(sp)
 8ac:	b7f5                	j	898 <malloc+0xea>
