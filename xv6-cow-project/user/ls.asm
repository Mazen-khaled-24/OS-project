
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	314080e7          	jalr	788(ra) # 320 <strlen>
  14:	02051793          	slli	a5,a0,0x20
  18:	9381                	srli	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	addi	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	00000097          	auipc	ra,0x0
  3c:	2e8080e7          	jalr	744(ra) # 320 <strlen>
  40:	2501                	sext.w	a0,a0
  42:	47b5                	li	a5,13
  44:	00a7f863          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  48:	8526                	mv	a0,s1
  4a:	70a2                	ld	ra,40(sp)
  4c:	7402                	ld	s0,32(sp)
  4e:	64e2                	ld	s1,24(sp)
  50:	6145                	addi	sp,sp,48
  52:	8082                	ret
  54:	e84a                	sd	s2,16(sp)
  56:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  58:	8526                	mv	a0,s1
  5a:	00000097          	auipc	ra,0x0
  5e:	2c6080e7          	jalr	710(ra) # 320 <strlen>
  62:	00001997          	auipc	s3,0x1
  66:	f3e98993          	addi	s3,s3,-194 # fa0 <buf.0>
  6a:	0005061b          	sext.w	a2,a0
  6e:	85a6                	mv	a1,s1
  70:	854e                	mv	a0,s3
  72:	00000097          	auipc	ra,0x0
  76:	420080e7          	jalr	1056(ra) # 492 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7a:	8526                	mv	a0,s1
  7c:	00000097          	auipc	ra,0x0
  80:	2a4080e7          	jalr	676(ra) # 320 <strlen>
  84:	0005091b          	sext.w	s2,a0
  88:	8526                	mv	a0,s1
  8a:	00000097          	auipc	ra,0x0
  8e:	296080e7          	jalr	662(ra) # 320 <strlen>
  92:	1902                	slli	s2,s2,0x20
  94:	02095913          	srli	s2,s2,0x20
  98:	4639                	li	a2,14
  9a:	9e09                	subw	a2,a2,a0
  9c:	02000593          	li	a1,32
  a0:	01298533          	add	a0,s3,s2
  a4:	00000097          	auipc	ra,0x0
  a8:	2a6080e7          	jalr	678(ra) # 34a <memset>
  return buf;
  ac:	84ce                	mv	s1,s3
  ae:	6942                	ld	s2,16(sp)
  b0:	69a2                	ld	s3,8(sp)
  b2:	bf59                	j	48 <fmtname+0x48>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	addi	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	25213823          	sd	s2,592(sp)
  c4:	1c80                	addi	s0,sp,624
  c6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  c8:	4581                	li	a1,0
  ca:	00000097          	auipc	ra,0x0
  ce:	4ba080e7          	jalr	1210(ra) # 584 <open>
  d2:	06054963          	bltz	a0,144 <ls+0x90>
  d6:	24913c23          	sd	s1,600(sp)
  da:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  dc:	d9840593          	addi	a1,s0,-616
  e0:	00000097          	auipc	ra,0x0
  e4:	4bc080e7          	jalr	1212(ra) # 59c <fstat>
  e8:	06054963          	bltz	a0,15a <ls+0xa6>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  ec:	da041783          	lh	a5,-608(s0)
  f0:	4705                	li	a4,1
  f2:	08e78663          	beq	a5,a4,17e <ls+0xca>
  f6:	4709                	li	a4,2
  f8:	02e79663          	bne	a5,a4,124 <ls+0x70>
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
  fc:	854a                	mv	a0,s2
  fe:	00000097          	auipc	ra,0x0
 102:	f02080e7          	jalr	-254(ra) # 0 <fmtname>
 106:	85aa                	mv	a1,a0
 108:	da843703          	ld	a4,-600(s0)
 10c:	d9c42683          	lw	a3,-612(s0)
 110:	da041603          	lh	a2,-608(s0)
 114:	00001517          	auipc	a0,0x1
 118:	98450513          	addi	a0,a0,-1660 # a98 <malloc+0x134>
 11c:	00000097          	auipc	ra,0x0
 120:	790080e7          	jalr	1936(ra) # 8ac <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 124:	8526                	mv	a0,s1
 126:	00000097          	auipc	ra,0x0
 12a:	446080e7          	jalr	1094(ra) # 56c <close>
 12e:	25813483          	ld	s1,600(sp)
}
 132:	26813083          	ld	ra,616(sp)
 136:	26013403          	ld	s0,608(sp)
 13a:	25013903          	ld	s2,592(sp)
 13e:	27010113          	addi	sp,sp,624
 142:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 144:	864a                	mv	a2,s2
 146:	00001597          	auipc	a1,0x1
 14a:	92258593          	addi	a1,a1,-1758 # a68 <malloc+0x104>
 14e:	4509                	li	a0,2
 150:	00000097          	auipc	ra,0x0
 154:	72e080e7          	jalr	1838(ra) # 87e <fprintf>
    return;
 158:	bfe9                	j	132 <ls+0x7e>
    fprintf(2, "ls: cannot stat %s\n", path);
 15a:	864a                	mv	a2,s2
 15c:	00001597          	auipc	a1,0x1
 160:	92458593          	addi	a1,a1,-1756 # a80 <malloc+0x11c>
 164:	4509                	li	a0,2
 166:	00000097          	auipc	ra,0x0
 16a:	718080e7          	jalr	1816(ra) # 87e <fprintf>
    close(fd);
 16e:	8526                	mv	a0,s1
 170:	00000097          	auipc	ra,0x0
 174:	3fc080e7          	jalr	1020(ra) # 56c <close>
    return;
 178:	25813483          	ld	s1,600(sp)
 17c:	bf5d                	j	132 <ls+0x7e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 17e:	854a                	mv	a0,s2
 180:	00000097          	auipc	ra,0x0
 184:	1a0080e7          	jalr	416(ra) # 320 <strlen>
 188:	2541                	addiw	a0,a0,16
 18a:	20000793          	li	a5,512
 18e:	00a7fb63          	bgeu	a5,a0,1a4 <ls+0xf0>
      printf("ls: path too long\n");
 192:	00001517          	auipc	a0,0x1
 196:	91650513          	addi	a0,a0,-1770 # aa8 <malloc+0x144>
 19a:	00000097          	auipc	ra,0x0
 19e:	712080e7          	jalr	1810(ra) # 8ac <printf>
      break;
 1a2:	b749                	j	124 <ls+0x70>
 1a4:	25313423          	sd	s3,584(sp)
 1a8:	25413023          	sd	s4,576(sp)
 1ac:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 1b0:	85ca                	mv	a1,s2
 1b2:	dc040513          	addi	a0,s0,-576
 1b6:	00000097          	auipc	ra,0x0
 1ba:	122080e7          	jalr	290(ra) # 2d8 <strcpy>
    p = buf+strlen(buf);
 1be:	dc040513          	addi	a0,s0,-576
 1c2:	00000097          	auipc	ra,0x0
 1c6:	15e080e7          	jalr	350(ra) # 320 <strlen>
 1ca:	1502                	slli	a0,a0,0x20
 1cc:	9101                	srli	a0,a0,0x20
 1ce:	dc040793          	addi	a5,s0,-576
 1d2:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1d6:	00190993          	addi	s3,s2,1
 1da:	02f00793          	li	a5,47
 1de:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1e2:	00001a17          	auipc	s4,0x1
 1e6:	8dea0a13          	addi	s4,s4,-1826 # ac0 <malloc+0x15c>
        printf("ls: cannot stat %s\n", buf);
 1ea:	00001a97          	auipc	s5,0x1
 1ee:	896a8a93          	addi	s5,s5,-1898 # a80 <malloc+0x11c>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f2:	a801                	j	202 <ls+0x14e>
        printf("ls: cannot stat %s\n", buf);
 1f4:	dc040593          	addi	a1,s0,-576
 1f8:	8556                	mv	a0,s5
 1fa:	00000097          	auipc	ra,0x0
 1fe:	6b2080e7          	jalr	1714(ra) # 8ac <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 202:	4641                	li	a2,16
 204:	db040593          	addi	a1,s0,-592
 208:	8526                	mv	a0,s1
 20a:	00000097          	auipc	ra,0x0
 20e:	352080e7          	jalr	850(ra) # 55c <read>
 212:	47c1                	li	a5,16
 214:	04f51c63          	bne	a0,a5,26c <ls+0x1b8>
      if(de.inum == 0)
 218:	db045783          	lhu	a5,-592(s0)
 21c:	d3fd                	beqz	a5,202 <ls+0x14e>
      memmove(p, de.name, DIRSIZ);
 21e:	4639                	li	a2,14
 220:	db240593          	addi	a1,s0,-590
 224:	854e                	mv	a0,s3
 226:	00000097          	auipc	ra,0x0
 22a:	26c080e7          	jalr	620(ra) # 492 <memmove>
      p[DIRSIZ] = 0;
 22e:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 232:	d9840593          	addi	a1,s0,-616
 236:	dc040513          	addi	a0,s0,-576
 23a:	00000097          	auipc	ra,0x0
 23e:	1ca080e7          	jalr	458(ra) # 404 <stat>
 242:	fa0549e3          	bltz	a0,1f4 <ls+0x140>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 246:	dc040513          	addi	a0,s0,-576
 24a:	00000097          	auipc	ra,0x0
 24e:	db6080e7          	jalr	-586(ra) # 0 <fmtname>
 252:	85aa                	mv	a1,a0
 254:	da843703          	ld	a4,-600(s0)
 258:	d9c42683          	lw	a3,-612(s0)
 25c:	da041603          	lh	a2,-608(s0)
 260:	8552                	mv	a0,s4
 262:	00000097          	auipc	ra,0x0
 266:	64a080e7          	jalr	1610(ra) # 8ac <printf>
 26a:	bf61                	j	202 <ls+0x14e>
 26c:	24813983          	ld	s3,584(sp)
 270:	24013a03          	ld	s4,576(sp)
 274:	23813a83          	ld	s5,568(sp)
 278:	b575                	j	124 <ls+0x70>

000000000000027a <main>:

int
main(int argc, char *argv[])
{
 27a:	1101                	addi	sp,sp,-32
 27c:	ec06                	sd	ra,24(sp)
 27e:	e822                	sd	s0,16(sp)
 280:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 282:	4785                	li	a5,1
 284:	02a7db63          	bge	a5,a0,2ba <main+0x40>
 288:	e426                	sd	s1,8(sp)
 28a:	e04a                	sd	s2,0(sp)
 28c:	00858493          	addi	s1,a1,8
 290:	ffe5091b          	addiw	s2,a0,-2
 294:	02091793          	slli	a5,s2,0x20
 298:	01d7d913          	srli	s2,a5,0x1d
 29c:	05c1                	addi	a1,a1,16
 29e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a0:	6088                	ld	a0,0(s1)
 2a2:	00000097          	auipc	ra,0x0
 2a6:	e12080e7          	jalr	-494(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2aa:	04a1                	addi	s1,s1,8
 2ac:	ff249ae3          	bne	s1,s2,2a0 <main+0x26>
  exit(0);
 2b0:	4501                	li	a0,0
 2b2:	00000097          	auipc	ra,0x0
 2b6:	292080e7          	jalr	658(ra) # 544 <exit>
 2ba:	e426                	sd	s1,8(sp)
 2bc:	e04a                	sd	s2,0(sp)
    ls(".");
 2be:	00001517          	auipc	a0,0x1
 2c2:	81250513          	addi	a0,a0,-2030 # ad0 <malloc+0x16c>
 2c6:	00000097          	auipc	ra,0x0
 2ca:	dee080e7          	jalr	-530(ra) # b4 <ls>
    exit(0);
 2ce:	4501                	li	a0,0
 2d0:	00000097          	auipc	ra,0x0
 2d4:	274080e7          	jalr	628(ra) # 544 <exit>

00000000000002d8 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e422                	sd	s0,8(sp)
 2dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2de:	87aa                	mv	a5,a0
 2e0:	0585                	addi	a1,a1,1
 2e2:	0785                	addi	a5,a5,1
 2e4:	fff5c703          	lbu	a4,-1(a1)
 2e8:	fee78fa3          	sb	a4,-1(a5)
 2ec:	fb75                	bnez	a4,2e0 <strcpy+0x8>
    ;
  return os;
}
 2ee:	6422                	ld	s0,8(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret

00000000000002f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f4:	1141                	addi	sp,sp,-16
 2f6:	e422                	sd	s0,8(sp)
 2f8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2fa:	00054783          	lbu	a5,0(a0)
 2fe:	cb91                	beqz	a5,312 <strcmp+0x1e>
 300:	0005c703          	lbu	a4,0(a1)
 304:	00f71763          	bne	a4,a5,312 <strcmp+0x1e>
    p++, q++;
 308:	0505                	addi	a0,a0,1
 30a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 30c:	00054783          	lbu	a5,0(a0)
 310:	fbe5                	bnez	a5,300 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 312:	0005c503          	lbu	a0,0(a1)
}
 316:	40a7853b          	subw	a0,a5,a0
 31a:	6422                	ld	s0,8(sp)
 31c:	0141                	addi	sp,sp,16
 31e:	8082                	ret

0000000000000320 <strlen>:

uint
strlen(const char *s)
{
 320:	1141                	addi	sp,sp,-16
 322:	e422                	sd	s0,8(sp)
 324:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 326:	00054783          	lbu	a5,0(a0)
 32a:	cf91                	beqz	a5,346 <strlen+0x26>
 32c:	0505                	addi	a0,a0,1
 32e:	87aa                	mv	a5,a0
 330:	86be                	mv	a3,a5
 332:	0785                	addi	a5,a5,1
 334:	fff7c703          	lbu	a4,-1(a5)
 338:	ff65                	bnez	a4,330 <strlen+0x10>
 33a:	40a6853b          	subw	a0,a3,a0
 33e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 340:	6422                	ld	s0,8(sp)
 342:	0141                	addi	sp,sp,16
 344:	8082                	ret
  for(n = 0; s[n]; n++)
 346:	4501                	li	a0,0
 348:	bfe5                	j	340 <strlen+0x20>

000000000000034a <memset>:

void*
memset(void *dst, int c, uint n)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 350:	ca19                	beqz	a2,366 <memset+0x1c>
 352:	87aa                	mv	a5,a0
 354:	1602                	slli	a2,a2,0x20
 356:	9201                	srli	a2,a2,0x20
 358:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 35c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 360:	0785                	addi	a5,a5,1
 362:	fee79de3          	bne	a5,a4,35c <memset+0x12>
  }
  return dst;
}
 366:	6422                	ld	s0,8(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <strchr>:

char*
strchr(const char *s, char c)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e422                	sd	s0,8(sp)
 370:	0800                	addi	s0,sp,16
  for(; *s; s++)
 372:	00054783          	lbu	a5,0(a0)
 376:	cb99                	beqz	a5,38c <strchr+0x20>
    if(*s == c)
 378:	00f58763          	beq	a1,a5,386 <strchr+0x1a>
  for(; *s; s++)
 37c:	0505                	addi	a0,a0,1
 37e:	00054783          	lbu	a5,0(a0)
 382:	fbfd                	bnez	a5,378 <strchr+0xc>
      return (char*)s;
  return 0;
 384:	4501                	li	a0,0
}
 386:	6422                	ld	s0,8(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
  return 0;
 38c:	4501                	li	a0,0
 38e:	bfe5                	j	386 <strchr+0x1a>

0000000000000390 <gets>:

char*
gets(char *buf, int max)
{
 390:	711d                	addi	sp,sp,-96
 392:	ec86                	sd	ra,88(sp)
 394:	e8a2                	sd	s0,80(sp)
 396:	e4a6                	sd	s1,72(sp)
 398:	e0ca                	sd	s2,64(sp)
 39a:	fc4e                	sd	s3,56(sp)
 39c:	f852                	sd	s4,48(sp)
 39e:	f456                	sd	s5,40(sp)
 3a0:	f05a                	sd	s6,32(sp)
 3a2:	ec5e                	sd	s7,24(sp)
 3a4:	1080                	addi	s0,sp,96
 3a6:	8baa                	mv	s7,a0
 3a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3aa:	892a                	mv	s2,a0
 3ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3ae:	4aa9                	li	s5,10
 3b0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3b2:	89a6                	mv	s3,s1
 3b4:	2485                	addiw	s1,s1,1
 3b6:	0344d863          	bge	s1,s4,3e6 <gets+0x56>
    cc = read(0, &c, 1);
 3ba:	4605                	li	a2,1
 3bc:	faf40593          	addi	a1,s0,-81
 3c0:	4501                	li	a0,0
 3c2:	00000097          	auipc	ra,0x0
 3c6:	19a080e7          	jalr	410(ra) # 55c <read>
    if(cc < 1)
 3ca:	00a05e63          	blez	a0,3e6 <gets+0x56>
    buf[i++] = c;
 3ce:	faf44783          	lbu	a5,-81(s0)
 3d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3d6:	01578763          	beq	a5,s5,3e4 <gets+0x54>
 3da:	0905                	addi	s2,s2,1
 3dc:	fd679be3          	bne	a5,s6,3b2 <gets+0x22>
    buf[i++] = c;
 3e0:	89a6                	mv	s3,s1
 3e2:	a011                	j	3e6 <gets+0x56>
 3e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3e6:	99de                	add	s3,s3,s7
 3e8:	00098023          	sb	zero,0(s3)
  return buf;
}
 3ec:	855e                	mv	a0,s7
 3ee:	60e6                	ld	ra,88(sp)
 3f0:	6446                	ld	s0,80(sp)
 3f2:	64a6                	ld	s1,72(sp)
 3f4:	6906                	ld	s2,64(sp)
 3f6:	79e2                	ld	s3,56(sp)
 3f8:	7a42                	ld	s4,48(sp)
 3fa:	7aa2                	ld	s5,40(sp)
 3fc:	7b02                	ld	s6,32(sp)
 3fe:	6be2                	ld	s7,24(sp)
 400:	6125                	addi	sp,sp,96
 402:	8082                	ret

0000000000000404 <stat>:

int
stat(const char *n, struct stat *st)
{
 404:	1101                	addi	sp,sp,-32
 406:	ec06                	sd	ra,24(sp)
 408:	e822                	sd	s0,16(sp)
 40a:	e04a                	sd	s2,0(sp)
 40c:	1000                	addi	s0,sp,32
 40e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 410:	4581                	li	a1,0
 412:	00000097          	auipc	ra,0x0
 416:	172080e7          	jalr	370(ra) # 584 <open>
  if(fd < 0)
 41a:	02054663          	bltz	a0,446 <stat+0x42>
 41e:	e426                	sd	s1,8(sp)
 420:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 422:	85ca                	mv	a1,s2
 424:	00000097          	auipc	ra,0x0
 428:	178080e7          	jalr	376(ra) # 59c <fstat>
 42c:	892a                	mv	s2,a0
  close(fd);
 42e:	8526                	mv	a0,s1
 430:	00000097          	auipc	ra,0x0
 434:	13c080e7          	jalr	316(ra) # 56c <close>
  return r;
 438:	64a2                	ld	s1,8(sp)
}
 43a:	854a                	mv	a0,s2
 43c:	60e2                	ld	ra,24(sp)
 43e:	6442                	ld	s0,16(sp)
 440:	6902                	ld	s2,0(sp)
 442:	6105                	addi	sp,sp,32
 444:	8082                	ret
    return -1;
 446:	597d                	li	s2,-1
 448:	bfcd                	j	43a <stat+0x36>

000000000000044a <atoi>:

int
atoi(const char *s)
{
 44a:	1141                	addi	sp,sp,-16
 44c:	e422                	sd	s0,8(sp)
 44e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 450:	00054683          	lbu	a3,0(a0)
 454:	fd06879b          	addiw	a5,a3,-48
 458:	0ff7f793          	zext.b	a5,a5
 45c:	4625                	li	a2,9
 45e:	02f66863          	bltu	a2,a5,48e <atoi+0x44>
 462:	872a                	mv	a4,a0
  n = 0;
 464:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 466:	0705                	addi	a4,a4,1
 468:	0025179b          	slliw	a5,a0,0x2
 46c:	9fa9                	addw	a5,a5,a0
 46e:	0017979b          	slliw	a5,a5,0x1
 472:	9fb5                	addw	a5,a5,a3
 474:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 478:	00074683          	lbu	a3,0(a4)
 47c:	fd06879b          	addiw	a5,a3,-48
 480:	0ff7f793          	zext.b	a5,a5
 484:	fef671e3          	bgeu	a2,a5,466 <atoi+0x1c>
  return n;
}
 488:	6422                	ld	s0,8(sp)
 48a:	0141                	addi	sp,sp,16
 48c:	8082                	ret
  n = 0;
 48e:	4501                	li	a0,0
 490:	bfe5                	j	488 <atoi+0x3e>

0000000000000492 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 492:	1141                	addi	sp,sp,-16
 494:	e422                	sd	s0,8(sp)
 496:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 498:	02b57463          	bgeu	a0,a1,4c0 <memmove+0x2e>
    while(n-- > 0)
 49c:	00c05f63          	blez	a2,4ba <memmove+0x28>
 4a0:	1602                	slli	a2,a2,0x20
 4a2:	9201                	srli	a2,a2,0x20
 4a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4a8:	872a                	mv	a4,a0
      *dst++ = *src++;
 4aa:	0585                	addi	a1,a1,1
 4ac:	0705                	addi	a4,a4,1
 4ae:	fff5c683          	lbu	a3,-1(a1)
 4b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4b6:	fef71ae3          	bne	a4,a5,4aa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4ba:	6422                	ld	s0,8(sp)
 4bc:	0141                	addi	sp,sp,16
 4be:	8082                	ret
    dst += n;
 4c0:	00c50733          	add	a4,a0,a2
    src += n;
 4c4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4c6:	fec05ae3          	blez	a2,4ba <memmove+0x28>
 4ca:	fff6079b          	addiw	a5,a2,-1
 4ce:	1782                	slli	a5,a5,0x20
 4d0:	9381                	srli	a5,a5,0x20
 4d2:	fff7c793          	not	a5,a5
 4d6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4d8:	15fd                	addi	a1,a1,-1
 4da:	177d                	addi	a4,a4,-1
 4dc:	0005c683          	lbu	a3,0(a1)
 4e0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4e4:	fee79ae3          	bne	a5,a4,4d8 <memmove+0x46>
 4e8:	bfc9                	j	4ba <memmove+0x28>

00000000000004ea <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ea:	1141                	addi	sp,sp,-16
 4ec:	e422                	sd	s0,8(sp)
 4ee:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4f0:	ca05                	beqz	a2,520 <memcmp+0x36>
 4f2:	fff6069b          	addiw	a3,a2,-1
 4f6:	1682                	slli	a3,a3,0x20
 4f8:	9281                	srli	a3,a3,0x20
 4fa:	0685                	addi	a3,a3,1
 4fc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 4fe:	00054783          	lbu	a5,0(a0)
 502:	0005c703          	lbu	a4,0(a1)
 506:	00e79863          	bne	a5,a4,516 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 50a:	0505                	addi	a0,a0,1
    p2++;
 50c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 50e:	fed518e3          	bne	a0,a3,4fe <memcmp+0x14>
  }
  return 0;
 512:	4501                	li	a0,0
 514:	a019                	j	51a <memcmp+0x30>
      return *p1 - *p2;
 516:	40e7853b          	subw	a0,a5,a4
}
 51a:	6422                	ld	s0,8(sp)
 51c:	0141                	addi	sp,sp,16
 51e:	8082                	ret
  return 0;
 520:	4501                	li	a0,0
 522:	bfe5                	j	51a <memcmp+0x30>

0000000000000524 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 524:	1141                	addi	sp,sp,-16
 526:	e406                	sd	ra,8(sp)
 528:	e022                	sd	s0,0(sp)
 52a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 52c:	00000097          	auipc	ra,0x0
 530:	f66080e7          	jalr	-154(ra) # 492 <memmove>
}
 534:	60a2                	ld	ra,8(sp)
 536:	6402                	ld	s0,0(sp)
 538:	0141                	addi	sp,sp,16
 53a:	8082                	ret

000000000000053c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 53c:	4885                	li	a7,1
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <exit>:
.global exit
exit:
 li a7, SYS_exit
 544:	4889                	li	a7,2
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <wait>:
.global wait
wait:
 li a7, SYS_wait
 54c:	488d                	li	a7,3
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 554:	4891                	li	a7,4
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <read>:
.global read
read:
 li a7, SYS_read
 55c:	4895                	li	a7,5
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <write>:
.global write
write:
 li a7, SYS_write
 564:	48c1                	li	a7,16
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <close>:
.global close
close:
 li a7, SYS_close
 56c:	48d5                	li	a7,21
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <kill>:
.global kill
kill:
 li a7, SYS_kill
 574:	4899                	li	a7,6
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <exec>:
.global exec
exec:
 li a7, SYS_exec
 57c:	489d                	li	a7,7
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <open>:
.global open
open:
 li a7, SYS_open
 584:	48bd                	li	a7,15
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 58c:	48c5                	li	a7,17
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 594:	48c9                	li	a7,18
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 59c:	48a1                	li	a7,8
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <link>:
.global link
link:
 li a7, SYS_link
 5a4:	48cd                	li	a7,19
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5ac:	48d1                	li	a7,20
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5b4:	48a5                	li	a7,9
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <dup>:
.global dup
dup:
 li a7, SYS_dup
 5bc:	48a9                	li	a7,10
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5c4:	48ad                	li	a7,11
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5cc:	48b1                	li	a7,12
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5d4:	48b5                	li	a7,13
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5dc:	48b9                	li	a7,14
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5e4:	1101                	addi	sp,sp,-32
 5e6:	ec06                	sd	ra,24(sp)
 5e8:	e822                	sd	s0,16(sp)
 5ea:	1000                	addi	s0,sp,32
 5ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5f0:	4605                	li	a2,1
 5f2:	fef40593          	addi	a1,s0,-17
 5f6:	00000097          	auipc	ra,0x0
 5fa:	f6e080e7          	jalr	-146(ra) # 564 <write>
}
 5fe:	60e2                	ld	ra,24(sp)
 600:	6442                	ld	s0,16(sp)
 602:	6105                	addi	sp,sp,32
 604:	8082                	ret

0000000000000606 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 606:	7139                	addi	sp,sp,-64
 608:	fc06                	sd	ra,56(sp)
 60a:	f822                	sd	s0,48(sp)
 60c:	f426                	sd	s1,40(sp)
 60e:	0080                	addi	s0,sp,64
 610:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 612:	c299                	beqz	a3,618 <printint+0x12>
 614:	0805cb63          	bltz	a1,6aa <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 618:	2581                	sext.w	a1,a1
  neg = 0;
 61a:	4881                	li	a7,0
 61c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 620:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 622:	2601                	sext.w	a2,a2
 624:	00000517          	auipc	a0,0x0
 628:	51450513          	addi	a0,a0,1300 # b38 <digits>
 62c:	883a                	mv	a6,a4
 62e:	2705                	addiw	a4,a4,1
 630:	02c5f7bb          	remuw	a5,a1,a2
 634:	1782                	slli	a5,a5,0x20
 636:	9381                	srli	a5,a5,0x20
 638:	97aa                	add	a5,a5,a0
 63a:	0007c783          	lbu	a5,0(a5)
 63e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 642:	0005879b          	sext.w	a5,a1
 646:	02c5d5bb          	divuw	a1,a1,a2
 64a:	0685                	addi	a3,a3,1
 64c:	fec7f0e3          	bgeu	a5,a2,62c <printint+0x26>
  if(neg)
 650:	00088c63          	beqz	a7,668 <printint+0x62>
    buf[i++] = '-';
 654:	fd070793          	addi	a5,a4,-48
 658:	00878733          	add	a4,a5,s0
 65c:	02d00793          	li	a5,45
 660:	fef70823          	sb	a5,-16(a4)
 664:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 668:	02e05c63          	blez	a4,6a0 <printint+0x9a>
 66c:	f04a                	sd	s2,32(sp)
 66e:	ec4e                	sd	s3,24(sp)
 670:	fc040793          	addi	a5,s0,-64
 674:	00e78933          	add	s2,a5,a4
 678:	fff78993          	addi	s3,a5,-1
 67c:	99ba                	add	s3,s3,a4
 67e:	377d                	addiw	a4,a4,-1
 680:	1702                	slli	a4,a4,0x20
 682:	9301                	srli	a4,a4,0x20
 684:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 688:	fff94583          	lbu	a1,-1(s2)
 68c:	8526                	mv	a0,s1
 68e:	00000097          	auipc	ra,0x0
 692:	f56080e7          	jalr	-170(ra) # 5e4 <putc>
  while(--i >= 0)
 696:	197d                	addi	s2,s2,-1
 698:	ff3918e3          	bne	s2,s3,688 <printint+0x82>
 69c:	7902                	ld	s2,32(sp)
 69e:	69e2                	ld	s3,24(sp)
}
 6a0:	70e2                	ld	ra,56(sp)
 6a2:	7442                	ld	s0,48(sp)
 6a4:	74a2                	ld	s1,40(sp)
 6a6:	6121                	addi	sp,sp,64
 6a8:	8082                	ret
    x = -xx;
 6aa:	40b005bb          	negw	a1,a1
    neg = 1;
 6ae:	4885                	li	a7,1
    x = -xx;
 6b0:	b7b5                	j	61c <printint+0x16>

00000000000006b2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6b2:	715d                	addi	sp,sp,-80
 6b4:	e486                	sd	ra,72(sp)
 6b6:	e0a2                	sd	s0,64(sp)
 6b8:	f84a                	sd	s2,48(sp)
 6ba:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6bc:	0005c903          	lbu	s2,0(a1)
 6c0:	1a090a63          	beqz	s2,874 <vprintf+0x1c2>
 6c4:	fc26                	sd	s1,56(sp)
 6c6:	f44e                	sd	s3,40(sp)
 6c8:	f052                	sd	s4,32(sp)
 6ca:	ec56                	sd	s5,24(sp)
 6cc:	e85a                	sd	s6,16(sp)
 6ce:	e45e                	sd	s7,8(sp)
 6d0:	8aaa                	mv	s5,a0
 6d2:	8bb2                	mv	s7,a2
 6d4:	00158493          	addi	s1,a1,1
  state = 0;
 6d8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6da:	02500a13          	li	s4,37
 6de:	4b55                	li	s6,21
 6e0:	a839                	j	6fe <vprintf+0x4c>
        putc(fd, c);
 6e2:	85ca                	mv	a1,s2
 6e4:	8556                	mv	a0,s5
 6e6:	00000097          	auipc	ra,0x0
 6ea:	efe080e7          	jalr	-258(ra) # 5e4 <putc>
 6ee:	a019                	j	6f4 <vprintf+0x42>
    } else if(state == '%'){
 6f0:	01498d63          	beq	s3,s4,70a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 6f4:	0485                	addi	s1,s1,1
 6f6:	fff4c903          	lbu	s2,-1(s1)
 6fa:	16090763          	beqz	s2,868 <vprintf+0x1b6>
    if(state == 0){
 6fe:	fe0999e3          	bnez	s3,6f0 <vprintf+0x3e>
      if(c == '%'){
 702:	ff4910e3          	bne	s2,s4,6e2 <vprintf+0x30>
        state = '%';
 706:	89d2                	mv	s3,s4
 708:	b7f5                	j	6f4 <vprintf+0x42>
      if(c == 'd'){
 70a:	13490463          	beq	s2,s4,832 <vprintf+0x180>
 70e:	f9d9079b          	addiw	a5,s2,-99
 712:	0ff7f793          	zext.b	a5,a5
 716:	12fb6763          	bltu	s6,a5,844 <vprintf+0x192>
 71a:	f9d9079b          	addiw	a5,s2,-99
 71e:	0ff7f713          	zext.b	a4,a5
 722:	12eb6163          	bltu	s6,a4,844 <vprintf+0x192>
 726:	00271793          	slli	a5,a4,0x2
 72a:	00000717          	auipc	a4,0x0
 72e:	3b670713          	addi	a4,a4,950 # ae0 <malloc+0x17c>
 732:	97ba                	add	a5,a5,a4
 734:	439c                	lw	a5,0(a5)
 736:	97ba                	add	a5,a5,a4
 738:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 73a:	008b8913          	addi	s2,s7,8
 73e:	4685                	li	a3,1
 740:	4629                	li	a2,10
 742:	000ba583          	lw	a1,0(s7)
 746:	8556                	mv	a0,s5
 748:	00000097          	auipc	ra,0x0
 74c:	ebe080e7          	jalr	-322(ra) # 606 <printint>
 750:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 752:	4981                	li	s3,0
 754:	b745                	j	6f4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 756:	008b8913          	addi	s2,s7,8
 75a:	4681                	li	a3,0
 75c:	4629                	li	a2,10
 75e:	000ba583          	lw	a1,0(s7)
 762:	8556                	mv	a0,s5
 764:	00000097          	auipc	ra,0x0
 768:	ea2080e7          	jalr	-350(ra) # 606 <printint>
 76c:	8bca                	mv	s7,s2
      state = 0;
 76e:	4981                	li	s3,0
 770:	b751                	j	6f4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 772:	008b8913          	addi	s2,s7,8
 776:	4681                	li	a3,0
 778:	4641                	li	a2,16
 77a:	000ba583          	lw	a1,0(s7)
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	e86080e7          	jalr	-378(ra) # 606 <printint>
 788:	8bca                	mv	s7,s2
      state = 0;
 78a:	4981                	li	s3,0
 78c:	b7a5                	j	6f4 <vprintf+0x42>
 78e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 790:	008b8c13          	addi	s8,s7,8
 794:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 798:	03000593          	li	a1,48
 79c:	8556                	mv	a0,s5
 79e:	00000097          	auipc	ra,0x0
 7a2:	e46080e7          	jalr	-442(ra) # 5e4 <putc>
  putc(fd, 'x');
 7a6:	07800593          	li	a1,120
 7aa:	8556                	mv	a0,s5
 7ac:	00000097          	auipc	ra,0x0
 7b0:	e38080e7          	jalr	-456(ra) # 5e4 <putc>
 7b4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7b6:	00000b97          	auipc	s7,0x0
 7ba:	382b8b93          	addi	s7,s7,898 # b38 <digits>
 7be:	03c9d793          	srli	a5,s3,0x3c
 7c2:	97de                	add	a5,a5,s7
 7c4:	0007c583          	lbu	a1,0(a5)
 7c8:	8556                	mv	a0,s5
 7ca:	00000097          	auipc	ra,0x0
 7ce:	e1a080e7          	jalr	-486(ra) # 5e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d2:	0992                	slli	s3,s3,0x4
 7d4:	397d                	addiw	s2,s2,-1
 7d6:	fe0914e3          	bnez	s2,7be <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7da:	8be2                	mv	s7,s8
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	6c02                	ld	s8,0(sp)
 7e0:	bf11                	j	6f4 <vprintf+0x42>
        s = va_arg(ap, char*);
 7e2:	008b8993          	addi	s3,s7,8
 7e6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 7ea:	02090163          	beqz	s2,80c <vprintf+0x15a>
        while(*s != 0){
 7ee:	00094583          	lbu	a1,0(s2)
 7f2:	c9a5                	beqz	a1,862 <vprintf+0x1b0>
          putc(fd, *s);
 7f4:	8556                	mv	a0,s5
 7f6:	00000097          	auipc	ra,0x0
 7fa:	dee080e7          	jalr	-530(ra) # 5e4 <putc>
          s++;
 7fe:	0905                	addi	s2,s2,1
        while(*s != 0){
 800:	00094583          	lbu	a1,0(s2)
 804:	f9e5                	bnez	a1,7f4 <vprintf+0x142>
        s = va_arg(ap, char*);
 806:	8bce                	mv	s7,s3
      state = 0;
 808:	4981                	li	s3,0
 80a:	b5ed                	j	6f4 <vprintf+0x42>
          s = "(null)";
 80c:	00000917          	auipc	s2,0x0
 810:	2cc90913          	addi	s2,s2,716 # ad8 <malloc+0x174>
        while(*s != 0){
 814:	02800593          	li	a1,40
 818:	bff1                	j	7f4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 81a:	008b8913          	addi	s2,s7,8
 81e:	000bc583          	lbu	a1,0(s7)
 822:	8556                	mv	a0,s5
 824:	00000097          	auipc	ra,0x0
 828:	dc0080e7          	jalr	-576(ra) # 5e4 <putc>
 82c:	8bca                	mv	s7,s2
      state = 0;
 82e:	4981                	li	s3,0
 830:	b5d1                	j	6f4 <vprintf+0x42>
        putc(fd, c);
 832:	02500593          	li	a1,37
 836:	8556                	mv	a0,s5
 838:	00000097          	auipc	ra,0x0
 83c:	dac080e7          	jalr	-596(ra) # 5e4 <putc>
      state = 0;
 840:	4981                	li	s3,0
 842:	bd4d                	j	6f4 <vprintf+0x42>
        putc(fd, '%');
 844:	02500593          	li	a1,37
 848:	8556                	mv	a0,s5
 84a:	00000097          	auipc	ra,0x0
 84e:	d9a080e7          	jalr	-614(ra) # 5e4 <putc>
        putc(fd, c);
 852:	85ca                	mv	a1,s2
 854:	8556                	mv	a0,s5
 856:	00000097          	auipc	ra,0x0
 85a:	d8e080e7          	jalr	-626(ra) # 5e4 <putc>
      state = 0;
 85e:	4981                	li	s3,0
 860:	bd51                	j	6f4 <vprintf+0x42>
        s = va_arg(ap, char*);
 862:	8bce                	mv	s7,s3
      state = 0;
 864:	4981                	li	s3,0
 866:	b579                	j	6f4 <vprintf+0x42>
 868:	74e2                	ld	s1,56(sp)
 86a:	79a2                	ld	s3,40(sp)
 86c:	7a02                	ld	s4,32(sp)
 86e:	6ae2                	ld	s5,24(sp)
 870:	6b42                	ld	s6,16(sp)
 872:	6ba2                	ld	s7,8(sp)
    }
  }
}
 874:	60a6                	ld	ra,72(sp)
 876:	6406                	ld	s0,64(sp)
 878:	7942                	ld	s2,48(sp)
 87a:	6161                	addi	sp,sp,80
 87c:	8082                	ret

000000000000087e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 87e:	715d                	addi	sp,sp,-80
 880:	ec06                	sd	ra,24(sp)
 882:	e822                	sd	s0,16(sp)
 884:	1000                	addi	s0,sp,32
 886:	e010                	sd	a2,0(s0)
 888:	e414                	sd	a3,8(s0)
 88a:	e818                	sd	a4,16(s0)
 88c:	ec1c                	sd	a5,24(s0)
 88e:	03043023          	sd	a6,32(s0)
 892:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 896:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 89a:	8622                	mv	a2,s0
 89c:	00000097          	auipc	ra,0x0
 8a0:	e16080e7          	jalr	-490(ra) # 6b2 <vprintf>
}
 8a4:	60e2                	ld	ra,24(sp)
 8a6:	6442                	ld	s0,16(sp)
 8a8:	6161                	addi	sp,sp,80
 8aa:	8082                	ret

00000000000008ac <printf>:

void
printf(const char *fmt, ...)
{
 8ac:	711d                	addi	sp,sp,-96
 8ae:	ec06                	sd	ra,24(sp)
 8b0:	e822                	sd	s0,16(sp)
 8b2:	1000                	addi	s0,sp,32
 8b4:	e40c                	sd	a1,8(s0)
 8b6:	e810                	sd	a2,16(s0)
 8b8:	ec14                	sd	a3,24(s0)
 8ba:	f018                	sd	a4,32(s0)
 8bc:	f41c                	sd	a5,40(s0)
 8be:	03043823          	sd	a6,48(s0)
 8c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8c6:	00840613          	addi	a2,s0,8
 8ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8ce:	85aa                	mv	a1,a0
 8d0:	4505                	li	a0,1
 8d2:	00000097          	auipc	ra,0x0
 8d6:	de0080e7          	jalr	-544(ra) # 6b2 <vprintf>
}
 8da:	60e2                	ld	ra,24(sp)
 8dc:	6442                	ld	s0,16(sp)
 8de:	6125                	addi	sp,sp,96
 8e0:	8082                	ret

00000000000008e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8e2:	1141                	addi	sp,sp,-16
 8e4:	e422                	sd	s0,8(sp)
 8e6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8e8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ec:	00000797          	auipc	a5,0x0
 8f0:	6ac7b783          	ld	a5,1708(a5) # f98 <freep>
 8f4:	a02d                	j	91e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8f6:	4618                	lw	a4,8(a2)
 8f8:	9f2d                	addw	a4,a4,a1
 8fa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8fe:	6398                	ld	a4,0(a5)
 900:	6310                	ld	a2,0(a4)
 902:	a83d                	j	940 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 904:	ff852703          	lw	a4,-8(a0)
 908:	9f31                	addw	a4,a4,a2
 90a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 90c:	ff053683          	ld	a3,-16(a0)
 910:	a091                	j	954 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 912:	6398                	ld	a4,0(a5)
 914:	00e7e463          	bltu	a5,a4,91c <free+0x3a>
 918:	00e6ea63          	bltu	a3,a4,92c <free+0x4a>
{
 91c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 91e:	fed7fae3          	bgeu	a5,a3,912 <free+0x30>
 922:	6398                	ld	a4,0(a5)
 924:	00e6e463          	bltu	a3,a4,92c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 928:	fee7eae3          	bltu	a5,a4,91c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 92c:	ff852583          	lw	a1,-8(a0)
 930:	6390                	ld	a2,0(a5)
 932:	02059813          	slli	a6,a1,0x20
 936:	01c85713          	srli	a4,a6,0x1c
 93a:	9736                	add	a4,a4,a3
 93c:	fae60de3          	beq	a2,a4,8f6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 940:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 944:	4790                	lw	a2,8(a5)
 946:	02061593          	slli	a1,a2,0x20
 94a:	01c5d713          	srli	a4,a1,0x1c
 94e:	973e                	add	a4,a4,a5
 950:	fae68ae3          	beq	a3,a4,904 <free+0x22>
    p->s.ptr = bp->s.ptr;
 954:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 956:	00000717          	auipc	a4,0x0
 95a:	64f73123          	sd	a5,1602(a4) # f98 <freep>
}
 95e:	6422                	ld	s0,8(sp)
 960:	0141                	addi	sp,sp,16
 962:	8082                	ret

0000000000000964 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 964:	7139                	addi	sp,sp,-64
 966:	fc06                	sd	ra,56(sp)
 968:	f822                	sd	s0,48(sp)
 96a:	f426                	sd	s1,40(sp)
 96c:	ec4e                	sd	s3,24(sp)
 96e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 970:	02051493          	slli	s1,a0,0x20
 974:	9081                	srli	s1,s1,0x20
 976:	04bd                	addi	s1,s1,15
 978:	8091                	srli	s1,s1,0x4
 97a:	0014899b          	addiw	s3,s1,1
 97e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 980:	00000517          	auipc	a0,0x0
 984:	61853503          	ld	a0,1560(a0) # f98 <freep>
 988:	c915                	beqz	a0,9bc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98c:	4798                	lw	a4,8(a5)
 98e:	08977e63          	bgeu	a4,s1,a2a <malloc+0xc6>
 992:	f04a                	sd	s2,32(sp)
 994:	e852                	sd	s4,16(sp)
 996:	e456                	sd	s5,8(sp)
 998:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 99a:	8a4e                	mv	s4,s3
 99c:	0009871b          	sext.w	a4,s3
 9a0:	6685                	lui	a3,0x1
 9a2:	00d77363          	bgeu	a4,a3,9a8 <malloc+0x44>
 9a6:	6a05                	lui	s4,0x1
 9a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9b0:	00000917          	auipc	s2,0x0
 9b4:	5e890913          	addi	s2,s2,1512 # f98 <freep>
  if(p == (char*)-1)
 9b8:	5afd                	li	s5,-1
 9ba:	a091                	j	9fe <malloc+0x9a>
 9bc:	f04a                	sd	s2,32(sp)
 9be:	e852                	sd	s4,16(sp)
 9c0:	e456                	sd	s5,8(sp)
 9c2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9c4:	00000797          	auipc	a5,0x0
 9c8:	5ec78793          	addi	a5,a5,1516 # fb0 <base>
 9cc:	00000717          	auipc	a4,0x0
 9d0:	5cf73623          	sd	a5,1484(a4) # f98 <freep>
 9d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9da:	b7c1                	j	99a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9dc:	6398                	ld	a4,0(a5)
 9de:	e118                	sd	a4,0(a0)
 9e0:	a08d                	j	a42 <malloc+0xde>
  hp->s.size = nu;
 9e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9e6:	0541                	addi	a0,a0,16
 9e8:	00000097          	auipc	ra,0x0
 9ec:	efa080e7          	jalr	-262(ra) # 8e2 <free>
  return freep;
 9f0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9f4:	c13d                	beqz	a0,a5a <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9f8:	4798                	lw	a4,8(a5)
 9fa:	02977463          	bgeu	a4,s1,a22 <malloc+0xbe>
    if(p == freep)
 9fe:	00093703          	ld	a4,0(s2)
 a02:	853e                	mv	a0,a5
 a04:	fef719e3          	bne	a4,a5,9f6 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a08:	8552                	mv	a0,s4
 a0a:	00000097          	auipc	ra,0x0
 a0e:	bc2080e7          	jalr	-1086(ra) # 5cc <sbrk>
  if(p == (char*)-1)
 a12:	fd5518e3          	bne	a0,s5,9e2 <malloc+0x7e>
        return 0;
 a16:	4501                	li	a0,0
 a18:	7902                	ld	s2,32(sp)
 a1a:	6a42                	ld	s4,16(sp)
 a1c:	6aa2                	ld	s5,8(sp)
 a1e:	6b02                	ld	s6,0(sp)
 a20:	a03d                	j	a4e <malloc+0xea>
 a22:	7902                	ld	s2,32(sp)
 a24:	6a42                	ld	s4,16(sp)
 a26:	6aa2                	ld	s5,8(sp)
 a28:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a2a:	fae489e3          	beq	s1,a4,9dc <malloc+0x78>
        p->s.size -= nunits;
 a2e:	4137073b          	subw	a4,a4,s3
 a32:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a34:	02071693          	slli	a3,a4,0x20
 a38:	01c6d713          	srli	a4,a3,0x1c
 a3c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a3e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a42:	00000717          	auipc	a4,0x0
 a46:	54a73b23          	sd	a0,1366(a4) # f98 <freep>
      return (void*)(p + 1);
 a4a:	01078513          	addi	a0,a5,16
  }
}
 a4e:	70e2                	ld	ra,56(sp)
 a50:	7442                	ld	s0,48(sp)
 a52:	74a2                	ld	s1,40(sp)
 a54:	69e2                	ld	s3,24(sp)
 a56:	6121                	addi	sp,sp,64
 a58:	8082                	ret
 a5a:	7902                	ld	s2,32(sp)
 a5c:	6a42                	ld	s4,16(sp)
 a5e:	6aa2                	ld	s5,8(sp)
 a60:	6b02                	ld	s6,0(sp)
 a62:	b7f5                	j	a4e <malloc+0xea>
