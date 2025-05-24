
user/_test_cow:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main() {
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  printf("Starting COW test\n");
   8:	00001517          	auipc	a0,0x1
   c:	88050513          	addi	a0,a0,-1920 # 888 <malloc+0x100>
  10:	00000097          	auipc	ra,0x0
  14:	6c0080e7          	jalr	1728(ra) # 6d0 <printf>

  // Allocate one page of memory and write something
  char *p = malloc(4096);
  18:	6505                	lui	a0,0x1
  1a:	00000097          	auipc	ra,0x0
  1e:	76e080e7          	jalr	1902(ra) # 788 <malloc>
  if (p == 0) {
  22:	c135                	beqz	a0,86 <main+0x86>
  24:	e426                	sd	s1,8(sp)
  26:	84aa                	mv	s1,a0
    printf("malloc failed\n");
    exit(1);
  }
  strcpy(p, "original data");
  28:	00001597          	auipc	a1,0x1
  2c:	88858593          	addi	a1,a1,-1912 # 8b0 <malloc+0x128>
  30:	00000097          	auipc	ra,0x0
  34:	0cc080e7          	jalr	204(ra) # fc <strcpy>

  int pid = fork();
  38:	00000097          	auipc	ra,0x0
  3c:	328080e7          	jalr	808(ra) # 360 <fork>
  if (pid < 0) {
  40:	06054163          	bltz	a0,a2 <main+0xa2>
    printf("fork failed\n");
    exit(1);
  }

  if (pid == 0) {
  44:	ed25                	bnez	a0,bc <main+0xbc>
    // Child process
    printf("Child reads: %s\n", p);
  46:	85a6                	mv	a1,s1
  48:	00001517          	auipc	a0,0x1
  4c:	88850513          	addi	a0,a0,-1912 # 8d0 <malloc+0x148>
  50:	00000097          	auipc	ra,0x0
  54:	680080e7          	jalr	1664(ra) # 6d0 <printf>
    strcpy(p, "child data");  // should trigger COW
  58:	00001597          	auipc	a1,0x1
  5c:	89058593          	addi	a1,a1,-1904 # 8e8 <malloc+0x160>
  60:	8526                	mv	a0,s1
  62:	00000097          	auipc	ra,0x0
  66:	09a080e7          	jalr	154(ra) # fc <strcpy>
    printf("Child writes and reads: %s\n", p);
  6a:	85a6                	mv	a1,s1
  6c:	00001517          	auipc	a0,0x1
  70:	88c50513          	addi	a0,a0,-1908 # 8f8 <malloc+0x170>
  74:	00000097          	auipc	ra,0x0
  78:	65c080e7          	jalr	1628(ra) # 6d0 <printf>
    exit(0);
  7c:	4501                	li	a0,0
  7e:	00000097          	auipc	ra,0x0
  82:	2ea080e7          	jalr	746(ra) # 368 <exit>
  86:	e426                	sd	s1,8(sp)
    printf("malloc failed\n");
  88:	00001517          	auipc	a0,0x1
  8c:	81850513          	addi	a0,a0,-2024 # 8a0 <malloc+0x118>
  90:	00000097          	auipc	ra,0x0
  94:	640080e7          	jalr	1600(ra) # 6d0 <printf>
    exit(1);
  98:	4505                	li	a0,1
  9a:	00000097          	auipc	ra,0x0
  9e:	2ce080e7          	jalr	718(ra) # 368 <exit>
    printf("fork failed\n");
  a2:	00001517          	auipc	a0,0x1
  a6:	81e50513          	addi	a0,a0,-2018 # 8c0 <malloc+0x138>
  aa:	00000097          	auipc	ra,0x0
  ae:	626080e7          	jalr	1574(ra) # 6d0 <printf>
    exit(1);
  b2:	4505                	li	a0,1
  b4:	00000097          	auipc	ra,0x0
  b8:	2b4080e7          	jalr	692(ra) # 368 <exit>
  } else {
    // Parent process
    wait(0);
  bc:	4501                	li	a0,0
  be:	00000097          	auipc	ra,0x0
  c2:	2b2080e7          	jalr	690(ra) # 370 <wait>
    printf("Parent still reads: %s\n", p);  // should remain unchanged
  c6:	85a6                	mv	a1,s1
  c8:	00001517          	auipc	a0,0x1
  cc:	85050513          	addi	a0,a0,-1968 # 918 <malloc+0x190>
  d0:	00000097          	auipc	ra,0x0
  d4:	600080e7          	jalr	1536(ra) # 6d0 <printf>
    free(p);
  d8:	8526                	mv	a0,s1
  da:	00000097          	auipc	ra,0x0
  de:	62c080e7          	jalr	1580(ra) # 706 <free>
  }

  printf("COW test finished\n");
  e2:	00001517          	auipc	a0,0x1
  e6:	84e50513          	addi	a0,a0,-1970 # 930 <malloc+0x1a8>
  ea:	00000097          	auipc	ra,0x0
  ee:	5e6080e7          	jalr	1510(ra) # 6d0 <printf>
  exit(0);
  f2:	4501                	li	a0,0
  f4:	00000097          	auipc	ra,0x0
  f8:	274080e7          	jalr	628(ra) # 368 <exit>

00000000000000fc <strcpy>:
  fc:	1141                	addi	sp,sp,-16
  fe:	e422                	sd	s0,8(sp)
 100:	0800                	addi	s0,sp,16
 102:	87aa                	mv	a5,a0
 104:	0585                	addi	a1,a1,1
 106:	0785                	addi	a5,a5,1
 108:	fff5c703          	lbu	a4,-1(a1)
 10c:	fee78fa3          	sb	a4,-1(a5)
 110:	fb75                	bnez	a4,104 <strcpy+0x8>
 112:	6422                	ld	s0,8(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:
 118:	1141                	addi	sp,sp,-16
 11a:	e422                	sd	s0,8(sp)
 11c:	0800                	addi	s0,sp,16
 11e:	00054783          	lbu	a5,0(a0)
 122:	cb91                	beqz	a5,136 <strcmp+0x1e>
 124:	0005c703          	lbu	a4,0(a1)
 128:	00f71763          	bne	a4,a5,136 <strcmp+0x1e>
 12c:	0505                	addi	a0,a0,1
 12e:	0585                	addi	a1,a1,1
 130:	00054783          	lbu	a5,0(a0)
 134:	fbe5                	bnez	a5,124 <strcmp+0xc>
 136:	0005c503          	lbu	a0,0(a1)
 13a:	40a7853b          	subw	a0,a5,a0
 13e:	6422                	ld	s0,8(sp)
 140:	0141                	addi	sp,sp,16
 142:	8082                	ret

0000000000000144 <strlen>:
 144:	1141                	addi	sp,sp,-16
 146:	e422                	sd	s0,8(sp)
 148:	0800                	addi	s0,sp,16
 14a:	00054783          	lbu	a5,0(a0)
 14e:	cf91                	beqz	a5,16a <strlen+0x26>
 150:	0505                	addi	a0,a0,1
 152:	87aa                	mv	a5,a0
 154:	86be                	mv	a3,a5
 156:	0785                	addi	a5,a5,1
 158:	fff7c703          	lbu	a4,-1(a5)
 15c:	ff65                	bnez	a4,154 <strlen+0x10>
 15e:	40a6853b          	subw	a0,a3,a0
 162:	2505                	addiw	a0,a0,1
 164:	6422                	ld	s0,8(sp)
 166:	0141                	addi	sp,sp,16
 168:	8082                	ret
 16a:	4501                	li	a0,0
 16c:	bfe5                	j	164 <strlen+0x20>

000000000000016e <memset>:
 16e:	1141                	addi	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	addi	s0,sp,16
 174:	ca19                	beqz	a2,18a <memset+0x1c>
 176:	87aa                	mv	a5,a0
 178:	1602                	slli	a2,a2,0x20
 17a:	9201                	srli	a2,a2,0x20
 17c:	00a60733          	add	a4,a2,a0
 180:	00b78023          	sb	a1,0(a5)
 184:	0785                	addi	a5,a5,1
 186:	fee79de3          	bne	a5,a4,180 <memset+0x12>
 18a:	6422                	ld	s0,8(sp)
 18c:	0141                	addi	sp,sp,16
 18e:	8082                	ret

0000000000000190 <strchr>:
 190:	1141                	addi	sp,sp,-16
 192:	e422                	sd	s0,8(sp)
 194:	0800                	addi	s0,sp,16
 196:	00054783          	lbu	a5,0(a0)
 19a:	cb99                	beqz	a5,1b0 <strchr+0x20>
 19c:	00f58763          	beq	a1,a5,1aa <strchr+0x1a>
 1a0:	0505                	addi	a0,a0,1
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	fbfd                	bnez	a5,19c <strchr+0xc>
 1a8:	4501                	li	a0,0
 1aa:	6422                	ld	s0,8(sp)
 1ac:	0141                	addi	sp,sp,16
 1ae:	8082                	ret
 1b0:	4501                	li	a0,0
 1b2:	bfe5                	j	1aa <strchr+0x1a>

00000000000001b4 <gets>:
 1b4:	711d                	addi	sp,sp,-96
 1b6:	ec86                	sd	ra,88(sp)
 1b8:	e8a2                	sd	s0,80(sp)
 1ba:	e4a6                	sd	s1,72(sp)
 1bc:	e0ca                	sd	s2,64(sp)
 1be:	fc4e                	sd	s3,56(sp)
 1c0:	f852                	sd	s4,48(sp)
 1c2:	f456                	sd	s5,40(sp)
 1c4:	f05a                	sd	s6,32(sp)
 1c6:	ec5e                	sd	s7,24(sp)
 1c8:	1080                	addi	s0,sp,96
 1ca:	8baa                	mv	s7,a0
 1cc:	8a2e                	mv	s4,a1
 1ce:	892a                	mv	s2,a0
 1d0:	4481                	li	s1,0
 1d2:	4aa9                	li	s5,10
 1d4:	4b35                	li	s6,13
 1d6:	89a6                	mv	s3,s1
 1d8:	2485                	addiw	s1,s1,1
 1da:	0344d863          	bge	s1,s4,20a <gets+0x56>
 1de:	4605                	li	a2,1
 1e0:	faf40593          	addi	a1,s0,-81
 1e4:	4501                	li	a0,0
 1e6:	00000097          	auipc	ra,0x0
 1ea:	19a080e7          	jalr	410(ra) # 380 <read>
 1ee:	00a05e63          	blez	a0,20a <gets+0x56>
 1f2:	faf44783          	lbu	a5,-81(s0)
 1f6:	00f90023          	sb	a5,0(s2)
 1fa:	01578763          	beq	a5,s5,208 <gets+0x54>
 1fe:	0905                	addi	s2,s2,1
 200:	fd679be3          	bne	a5,s6,1d6 <gets+0x22>
 204:	89a6                	mv	s3,s1
 206:	a011                	j	20a <gets+0x56>
 208:	89a6                	mv	s3,s1
 20a:	99de                	add	s3,s3,s7
 20c:	00098023          	sb	zero,0(s3)
 210:	855e                	mv	a0,s7
 212:	60e6                	ld	ra,88(sp)
 214:	6446                	ld	s0,80(sp)
 216:	64a6                	ld	s1,72(sp)
 218:	6906                	ld	s2,64(sp)
 21a:	79e2                	ld	s3,56(sp)
 21c:	7a42                	ld	s4,48(sp)
 21e:	7aa2                	ld	s5,40(sp)
 220:	7b02                	ld	s6,32(sp)
 222:	6be2                	ld	s7,24(sp)
 224:	6125                	addi	sp,sp,96
 226:	8082                	ret

0000000000000228 <stat>:
 228:	1101                	addi	sp,sp,-32
 22a:	ec06                	sd	ra,24(sp)
 22c:	e822                	sd	s0,16(sp)
 22e:	e04a                	sd	s2,0(sp)
 230:	1000                	addi	s0,sp,32
 232:	892e                	mv	s2,a1
 234:	4581                	li	a1,0
 236:	00000097          	auipc	ra,0x0
 23a:	172080e7          	jalr	370(ra) # 3a8 <open>
 23e:	02054663          	bltz	a0,26a <stat+0x42>
 242:	e426                	sd	s1,8(sp)
 244:	84aa                	mv	s1,a0
 246:	85ca                	mv	a1,s2
 248:	00000097          	auipc	ra,0x0
 24c:	178080e7          	jalr	376(ra) # 3c0 <fstat>
 250:	892a                	mv	s2,a0
 252:	8526                	mv	a0,s1
 254:	00000097          	auipc	ra,0x0
 258:	13c080e7          	jalr	316(ra) # 390 <close>
 25c:	64a2                	ld	s1,8(sp)
 25e:	854a                	mv	a0,s2
 260:	60e2                	ld	ra,24(sp)
 262:	6442                	ld	s0,16(sp)
 264:	6902                	ld	s2,0(sp)
 266:	6105                	addi	sp,sp,32
 268:	8082                	ret
 26a:	597d                	li	s2,-1
 26c:	bfcd                	j	25e <stat+0x36>

000000000000026e <atoi>:
 26e:	1141                	addi	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	addi	s0,sp,16
 274:	00054683          	lbu	a3,0(a0)
 278:	fd06879b          	addiw	a5,a3,-48
 27c:	0ff7f793          	zext.b	a5,a5
 280:	4625                	li	a2,9
 282:	02f66863          	bltu	a2,a5,2b2 <atoi+0x44>
 286:	872a                	mv	a4,a0
 288:	4501                	li	a0,0
 28a:	0705                	addi	a4,a4,1
 28c:	0025179b          	slliw	a5,a0,0x2
 290:	9fa9                	addw	a5,a5,a0
 292:	0017979b          	slliw	a5,a5,0x1
 296:	9fb5                	addw	a5,a5,a3
 298:	fd07851b          	addiw	a0,a5,-48
 29c:	00074683          	lbu	a3,0(a4)
 2a0:	fd06879b          	addiw	a5,a3,-48
 2a4:	0ff7f793          	zext.b	a5,a5
 2a8:	fef671e3          	bgeu	a2,a5,28a <atoi+0x1c>
 2ac:	6422                	ld	s0,8(sp)
 2ae:	0141                	addi	sp,sp,16
 2b0:	8082                	ret
 2b2:	4501                	li	a0,0
 2b4:	bfe5                	j	2ac <atoi+0x3e>

00000000000002b6 <memmove>:
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e422                	sd	s0,8(sp)
 2ba:	0800                	addi	s0,sp,16
 2bc:	02b57463          	bgeu	a0,a1,2e4 <memmove+0x2e>
 2c0:	00c05f63          	blez	a2,2de <memmove+0x28>
 2c4:	1602                	slli	a2,a2,0x20
 2c6:	9201                	srli	a2,a2,0x20
 2c8:	00c507b3          	add	a5,a0,a2
 2cc:	872a                	mv	a4,a0
 2ce:	0585                	addi	a1,a1,1
 2d0:	0705                	addi	a4,a4,1
 2d2:	fff5c683          	lbu	a3,-1(a1)
 2d6:	fed70fa3          	sb	a3,-1(a4)
 2da:	fef71ae3          	bne	a4,a5,2ce <memmove+0x18>
 2de:	6422                	ld	s0,8(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
 2e4:	00c50733          	add	a4,a0,a2
 2e8:	95b2                	add	a1,a1,a2
 2ea:	fec05ae3          	blez	a2,2de <memmove+0x28>
 2ee:	fff6079b          	addiw	a5,a2,-1
 2f2:	1782                	slli	a5,a5,0x20
 2f4:	9381                	srli	a5,a5,0x20
 2f6:	fff7c793          	not	a5,a5
 2fa:	97ba                	add	a5,a5,a4
 2fc:	15fd                	addi	a1,a1,-1
 2fe:	177d                	addi	a4,a4,-1
 300:	0005c683          	lbu	a3,0(a1)
 304:	00d70023          	sb	a3,0(a4)
 308:	fee79ae3          	bne	a5,a4,2fc <memmove+0x46>
 30c:	bfc9                	j	2de <memmove+0x28>

000000000000030e <memcmp>:
 30e:	1141                	addi	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	addi	s0,sp,16
 314:	ca05                	beqz	a2,344 <memcmp+0x36>
 316:	fff6069b          	addiw	a3,a2,-1
 31a:	1682                	slli	a3,a3,0x20
 31c:	9281                	srli	a3,a3,0x20
 31e:	0685                	addi	a3,a3,1
 320:	96aa                	add	a3,a3,a0
 322:	00054783          	lbu	a5,0(a0)
 326:	0005c703          	lbu	a4,0(a1)
 32a:	00e79863          	bne	a5,a4,33a <memcmp+0x2c>
 32e:	0505                	addi	a0,a0,1
 330:	0585                	addi	a1,a1,1
 332:	fed518e3          	bne	a0,a3,322 <memcmp+0x14>
 336:	4501                	li	a0,0
 338:	a019                	j	33e <memcmp+0x30>
 33a:	40e7853b          	subw	a0,a5,a4
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret
 344:	4501                	li	a0,0
 346:	bfe5                	j	33e <memcmp+0x30>

0000000000000348 <memcpy>:
 348:	1141                	addi	sp,sp,-16
 34a:	e406                	sd	ra,8(sp)
 34c:	e022                	sd	s0,0(sp)
 34e:	0800                	addi	s0,sp,16
 350:	00000097          	auipc	ra,0x0
 354:	f66080e7          	jalr	-154(ra) # 2b6 <memmove>
 358:	60a2                	ld	ra,8(sp)
 35a:	6402                	ld	s0,0(sp)
 35c:	0141                	addi	sp,sp,16
 35e:	8082                	ret

0000000000000360 <fork>:
 360:	4885                	li	a7,1
 362:	00000073          	ecall
 366:	8082                	ret

0000000000000368 <exit>:
 368:	4889                	li	a7,2
 36a:	00000073          	ecall
 36e:	8082                	ret

0000000000000370 <wait>:
 370:	488d                	li	a7,3
 372:	00000073          	ecall
 376:	8082                	ret

0000000000000378 <pipe>:
 378:	4891                	li	a7,4
 37a:	00000073          	ecall
 37e:	8082                	ret

0000000000000380 <read>:
 380:	4895                	li	a7,5
 382:	00000073          	ecall
 386:	8082                	ret

0000000000000388 <write>:
 388:	48c1                	li	a7,16
 38a:	00000073          	ecall
 38e:	8082                	ret

0000000000000390 <close>:
 390:	48d5                	li	a7,21
 392:	00000073          	ecall
 396:	8082                	ret

0000000000000398 <kill>:
 398:	4899                	li	a7,6
 39a:	00000073          	ecall
 39e:	8082                	ret

00000000000003a0 <exec>:
 3a0:	489d                	li	a7,7
 3a2:	00000073          	ecall
 3a6:	8082                	ret

00000000000003a8 <open>:
 3a8:	48bd                	li	a7,15
 3aa:	00000073          	ecall
 3ae:	8082                	ret

00000000000003b0 <mknod>:
 3b0:	48c5                	li	a7,17
 3b2:	00000073          	ecall
 3b6:	8082                	ret

00000000000003b8 <unlink>:
 3b8:	48c9                	li	a7,18
 3ba:	00000073          	ecall
 3be:	8082                	ret

00000000000003c0 <fstat>:
 3c0:	48a1                	li	a7,8
 3c2:	00000073          	ecall
 3c6:	8082                	ret

00000000000003c8 <link>:
 3c8:	48cd                	li	a7,19
 3ca:	00000073          	ecall
 3ce:	8082                	ret

00000000000003d0 <mkdir>:
 3d0:	48d1                	li	a7,20
 3d2:	00000073          	ecall
 3d6:	8082                	ret

00000000000003d8 <chdir>:
 3d8:	48a5                	li	a7,9
 3da:	00000073          	ecall
 3de:	8082                	ret

00000000000003e0 <dup>:
 3e0:	48a9                	li	a7,10
 3e2:	00000073          	ecall
 3e6:	8082                	ret

00000000000003e8 <getpid>:
 3e8:	48ad                	li	a7,11
 3ea:	00000073          	ecall
 3ee:	8082                	ret

00000000000003f0 <sbrk>:
 3f0:	48b1                	li	a7,12
 3f2:	00000073          	ecall
 3f6:	8082                	ret

00000000000003f8 <sleep>:
 3f8:	48b5                	li	a7,13
 3fa:	00000073          	ecall
 3fe:	8082                	ret

0000000000000400 <uptime>:
 400:	48b9                	li	a7,14
 402:	00000073          	ecall
 406:	8082                	ret

0000000000000408 <putc>:
 408:	1101                	addi	sp,sp,-32
 40a:	ec06                	sd	ra,24(sp)
 40c:	e822                	sd	s0,16(sp)
 40e:	1000                	addi	s0,sp,32
 410:	feb407a3          	sb	a1,-17(s0)
 414:	4605                	li	a2,1
 416:	fef40593          	addi	a1,s0,-17
 41a:	00000097          	auipc	ra,0x0
 41e:	f6e080e7          	jalr	-146(ra) # 388 <write>
 422:	60e2                	ld	ra,24(sp)
 424:	6442                	ld	s0,16(sp)
 426:	6105                	addi	sp,sp,32
 428:	8082                	ret

000000000000042a <printint>:
 42a:	7139                	addi	sp,sp,-64
 42c:	fc06                	sd	ra,56(sp)
 42e:	f822                	sd	s0,48(sp)
 430:	f426                	sd	s1,40(sp)
 432:	0080                	addi	s0,sp,64
 434:	84aa                	mv	s1,a0
 436:	c299                	beqz	a3,43c <printint+0x12>
 438:	0805cb63          	bltz	a1,4ce <printint+0xa4>
 43c:	2581                	sext.w	a1,a1
 43e:	4881                	li	a7,0
 440:	fc040693          	addi	a3,s0,-64
 444:	4701                	li	a4,0
 446:	2601                	sext.w	a2,a2
 448:	00000517          	auipc	a0,0x0
 44c:	56050513          	addi	a0,a0,1376 # 9a8 <digits>
 450:	883a                	mv	a6,a4
 452:	2705                	addiw	a4,a4,1
 454:	02c5f7bb          	remuw	a5,a1,a2
 458:	1782                	slli	a5,a5,0x20
 45a:	9381                	srli	a5,a5,0x20
 45c:	97aa                	add	a5,a5,a0
 45e:	0007c783          	lbu	a5,0(a5)
 462:	00f68023          	sb	a5,0(a3)
 466:	0005879b          	sext.w	a5,a1
 46a:	02c5d5bb          	divuw	a1,a1,a2
 46e:	0685                	addi	a3,a3,1
 470:	fec7f0e3          	bgeu	a5,a2,450 <printint+0x26>
 474:	00088c63          	beqz	a7,48c <printint+0x62>
 478:	fd070793          	addi	a5,a4,-48
 47c:	00878733          	add	a4,a5,s0
 480:	02d00793          	li	a5,45
 484:	fef70823          	sb	a5,-16(a4)
 488:	0028071b          	addiw	a4,a6,2
 48c:	02e05c63          	blez	a4,4c4 <printint+0x9a>
 490:	f04a                	sd	s2,32(sp)
 492:	ec4e                	sd	s3,24(sp)
 494:	fc040793          	addi	a5,s0,-64
 498:	00e78933          	add	s2,a5,a4
 49c:	fff78993          	addi	s3,a5,-1
 4a0:	99ba                	add	s3,s3,a4
 4a2:	377d                	addiw	a4,a4,-1
 4a4:	1702                	slli	a4,a4,0x20
 4a6:	9301                	srli	a4,a4,0x20
 4a8:	40e989b3          	sub	s3,s3,a4
 4ac:	fff94583          	lbu	a1,-1(s2)
 4b0:	8526                	mv	a0,s1
 4b2:	00000097          	auipc	ra,0x0
 4b6:	f56080e7          	jalr	-170(ra) # 408 <putc>
 4ba:	197d                	addi	s2,s2,-1
 4bc:	ff3918e3          	bne	s2,s3,4ac <printint+0x82>
 4c0:	7902                	ld	s2,32(sp)
 4c2:	69e2                	ld	s3,24(sp)
 4c4:	70e2                	ld	ra,56(sp)
 4c6:	7442                	ld	s0,48(sp)
 4c8:	74a2                	ld	s1,40(sp)
 4ca:	6121                	addi	sp,sp,64
 4cc:	8082                	ret
 4ce:	40b005bb          	negw	a1,a1
 4d2:	4885                	li	a7,1
 4d4:	b7b5                	j	440 <printint+0x16>

00000000000004d6 <vprintf>:
 4d6:	715d                	addi	sp,sp,-80
 4d8:	e486                	sd	ra,72(sp)
 4da:	e0a2                	sd	s0,64(sp)
 4dc:	f84a                	sd	s2,48(sp)
 4de:	0880                	addi	s0,sp,80
 4e0:	0005c903          	lbu	s2,0(a1)
 4e4:	1a090a63          	beqz	s2,698 <vprintf+0x1c2>
 4e8:	fc26                	sd	s1,56(sp)
 4ea:	f44e                	sd	s3,40(sp)
 4ec:	f052                	sd	s4,32(sp)
 4ee:	ec56                	sd	s5,24(sp)
 4f0:	e85a                	sd	s6,16(sp)
 4f2:	e45e                	sd	s7,8(sp)
 4f4:	8aaa                	mv	s5,a0
 4f6:	8bb2                	mv	s7,a2
 4f8:	00158493          	addi	s1,a1,1
 4fc:	4981                	li	s3,0
 4fe:	02500a13          	li	s4,37
 502:	4b55                	li	s6,21
 504:	a839                	j	522 <vprintf+0x4c>
 506:	85ca                	mv	a1,s2
 508:	8556                	mv	a0,s5
 50a:	00000097          	auipc	ra,0x0
 50e:	efe080e7          	jalr	-258(ra) # 408 <putc>
 512:	a019                	j	518 <vprintf+0x42>
 514:	01498d63          	beq	s3,s4,52e <vprintf+0x58>
 518:	0485                	addi	s1,s1,1
 51a:	fff4c903          	lbu	s2,-1(s1)
 51e:	16090763          	beqz	s2,68c <vprintf+0x1b6>
 522:	fe0999e3          	bnez	s3,514 <vprintf+0x3e>
 526:	ff4910e3          	bne	s2,s4,506 <vprintf+0x30>
 52a:	89d2                	mv	s3,s4
 52c:	b7f5                	j	518 <vprintf+0x42>
 52e:	13490463          	beq	s2,s4,656 <vprintf+0x180>
 532:	f9d9079b          	addiw	a5,s2,-99
 536:	0ff7f793          	zext.b	a5,a5
 53a:	12fb6763          	bltu	s6,a5,668 <vprintf+0x192>
 53e:	f9d9079b          	addiw	a5,s2,-99
 542:	0ff7f713          	zext.b	a4,a5
 546:	12eb6163          	bltu	s6,a4,668 <vprintf+0x192>
 54a:	00271793          	slli	a5,a4,0x2
 54e:	00000717          	auipc	a4,0x0
 552:	40270713          	addi	a4,a4,1026 # 950 <malloc+0x1c8>
 556:	97ba                	add	a5,a5,a4
 558:	439c                	lw	a5,0(a5)
 55a:	97ba                	add	a5,a5,a4
 55c:	8782                	jr	a5
 55e:	008b8913          	addi	s2,s7,8
 562:	4685                	li	a3,1
 564:	4629                	li	a2,10
 566:	000ba583          	lw	a1,0(s7)
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	ebe080e7          	jalr	-322(ra) # 42a <printint>
 574:	8bca                	mv	s7,s2
 576:	4981                	li	s3,0
 578:	b745                	j	518 <vprintf+0x42>
 57a:	008b8913          	addi	s2,s7,8
 57e:	4681                	li	a3,0
 580:	4629                	li	a2,10
 582:	000ba583          	lw	a1,0(s7)
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	ea2080e7          	jalr	-350(ra) # 42a <printint>
 590:	8bca                	mv	s7,s2
 592:	4981                	li	s3,0
 594:	b751                	j	518 <vprintf+0x42>
 596:	008b8913          	addi	s2,s7,8
 59a:	4681                	li	a3,0
 59c:	4641                	li	a2,16
 59e:	000ba583          	lw	a1,0(s7)
 5a2:	8556                	mv	a0,s5
 5a4:	00000097          	auipc	ra,0x0
 5a8:	e86080e7          	jalr	-378(ra) # 42a <printint>
 5ac:	8bca                	mv	s7,s2
 5ae:	4981                	li	s3,0
 5b0:	b7a5                	j	518 <vprintf+0x42>
 5b2:	e062                	sd	s8,0(sp)
 5b4:	008b8c13          	addi	s8,s7,8
 5b8:	000bb983          	ld	s3,0(s7)
 5bc:	03000593          	li	a1,48
 5c0:	8556                	mv	a0,s5
 5c2:	00000097          	auipc	ra,0x0
 5c6:	e46080e7          	jalr	-442(ra) # 408 <putc>
 5ca:	07800593          	li	a1,120
 5ce:	8556                	mv	a0,s5
 5d0:	00000097          	auipc	ra,0x0
 5d4:	e38080e7          	jalr	-456(ra) # 408 <putc>
 5d8:	4941                	li	s2,16
 5da:	00000b97          	auipc	s7,0x0
 5de:	3ceb8b93          	addi	s7,s7,974 # 9a8 <digits>
 5e2:	03c9d793          	srli	a5,s3,0x3c
 5e6:	97de                	add	a5,a5,s7
 5e8:	0007c583          	lbu	a1,0(a5)
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	e1a080e7          	jalr	-486(ra) # 408 <putc>
 5f6:	0992                	slli	s3,s3,0x4
 5f8:	397d                	addiw	s2,s2,-1
 5fa:	fe0914e3          	bnez	s2,5e2 <vprintf+0x10c>
 5fe:	8be2                	mv	s7,s8
 600:	4981                	li	s3,0
 602:	6c02                	ld	s8,0(sp)
 604:	bf11                	j	518 <vprintf+0x42>
 606:	008b8993          	addi	s3,s7,8
 60a:	000bb903          	ld	s2,0(s7)
 60e:	02090163          	beqz	s2,630 <vprintf+0x15a>
 612:	00094583          	lbu	a1,0(s2)
 616:	c9a5                	beqz	a1,686 <vprintf+0x1b0>
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	dee080e7          	jalr	-530(ra) # 408 <putc>
 622:	0905                	addi	s2,s2,1
 624:	00094583          	lbu	a1,0(s2)
 628:	f9e5                	bnez	a1,618 <vprintf+0x142>
 62a:	8bce                	mv	s7,s3
 62c:	4981                	li	s3,0
 62e:	b5ed                	j	518 <vprintf+0x42>
 630:	00000917          	auipc	s2,0x0
 634:	31890913          	addi	s2,s2,792 # 948 <malloc+0x1c0>
 638:	02800593          	li	a1,40
 63c:	bff1                	j	618 <vprintf+0x142>
 63e:	008b8913          	addi	s2,s7,8
 642:	000bc583          	lbu	a1,0(s7)
 646:	8556                	mv	a0,s5
 648:	00000097          	auipc	ra,0x0
 64c:	dc0080e7          	jalr	-576(ra) # 408 <putc>
 650:	8bca                	mv	s7,s2
 652:	4981                	li	s3,0
 654:	b5d1                	j	518 <vprintf+0x42>
 656:	02500593          	li	a1,37
 65a:	8556                	mv	a0,s5
 65c:	00000097          	auipc	ra,0x0
 660:	dac080e7          	jalr	-596(ra) # 408 <putc>
 664:	4981                	li	s3,0
 666:	bd4d                	j	518 <vprintf+0x42>
 668:	02500593          	li	a1,37
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	d9a080e7          	jalr	-614(ra) # 408 <putc>
 676:	85ca                	mv	a1,s2
 678:	8556                	mv	a0,s5
 67a:	00000097          	auipc	ra,0x0
 67e:	d8e080e7          	jalr	-626(ra) # 408 <putc>
 682:	4981                	li	s3,0
 684:	bd51                	j	518 <vprintf+0x42>
 686:	8bce                	mv	s7,s3
 688:	4981                	li	s3,0
 68a:	b579                	j	518 <vprintf+0x42>
 68c:	74e2                	ld	s1,56(sp)
 68e:	79a2                	ld	s3,40(sp)
 690:	7a02                	ld	s4,32(sp)
 692:	6ae2                	ld	s5,24(sp)
 694:	6b42                	ld	s6,16(sp)
 696:	6ba2                	ld	s7,8(sp)
 698:	60a6                	ld	ra,72(sp)
 69a:	6406                	ld	s0,64(sp)
 69c:	7942                	ld	s2,48(sp)
 69e:	6161                	addi	sp,sp,80
 6a0:	8082                	ret

00000000000006a2 <fprintf>:
 6a2:	715d                	addi	sp,sp,-80
 6a4:	ec06                	sd	ra,24(sp)
 6a6:	e822                	sd	s0,16(sp)
 6a8:	1000                	addi	s0,sp,32
 6aa:	e010                	sd	a2,0(s0)
 6ac:	e414                	sd	a3,8(s0)
 6ae:	e818                	sd	a4,16(s0)
 6b0:	ec1c                	sd	a5,24(s0)
 6b2:	03043023          	sd	a6,32(s0)
 6b6:	03143423          	sd	a7,40(s0)
 6ba:	fe843423          	sd	s0,-24(s0)
 6be:	8622                	mv	a2,s0
 6c0:	00000097          	auipc	ra,0x0
 6c4:	e16080e7          	jalr	-490(ra) # 4d6 <vprintf>
 6c8:	60e2                	ld	ra,24(sp)
 6ca:	6442                	ld	s0,16(sp)
 6cc:	6161                	addi	sp,sp,80
 6ce:	8082                	ret

00000000000006d0 <printf>:
 6d0:	711d                	addi	sp,sp,-96
 6d2:	ec06                	sd	ra,24(sp)
 6d4:	e822                	sd	s0,16(sp)
 6d6:	1000                	addi	s0,sp,32
 6d8:	e40c                	sd	a1,8(s0)
 6da:	e810                	sd	a2,16(s0)
 6dc:	ec14                	sd	a3,24(s0)
 6de:	f018                	sd	a4,32(s0)
 6e0:	f41c                	sd	a5,40(s0)
 6e2:	03043823          	sd	a6,48(s0)
 6e6:	03143c23          	sd	a7,56(s0)
 6ea:	00840613          	addi	a2,s0,8
 6ee:	fec43423          	sd	a2,-24(s0)
 6f2:	85aa                	mv	a1,a0
 6f4:	4505                	li	a0,1
 6f6:	00000097          	auipc	ra,0x0
 6fa:	de0080e7          	jalr	-544(ra) # 4d6 <vprintf>
 6fe:	60e2                	ld	ra,24(sp)
 700:	6442                	ld	s0,16(sp)
 702:	6125                	addi	sp,sp,96
 704:	8082                	ret

0000000000000706 <free>:
 706:	1141                	addi	sp,sp,-16
 708:	e422                	sd	s0,8(sp)
 70a:	0800                	addi	s0,sp,16
 70c:	ff050693          	addi	a3,a0,-16
 710:	00000797          	auipc	a5,0x0
 714:	6707b783          	ld	a5,1648(a5) # d80 <freep>
 718:	a02d                	j	742 <free+0x3c>
 71a:	4618                	lw	a4,8(a2)
 71c:	9f2d                	addw	a4,a4,a1
 71e:	fee52c23          	sw	a4,-8(a0)
 722:	6398                	ld	a4,0(a5)
 724:	6310                	ld	a2,0(a4)
 726:	a83d                	j	764 <free+0x5e>
 728:	ff852703          	lw	a4,-8(a0)
 72c:	9f31                	addw	a4,a4,a2
 72e:	c798                	sw	a4,8(a5)
 730:	ff053683          	ld	a3,-16(a0)
 734:	a091                	j	778 <free+0x72>
 736:	6398                	ld	a4,0(a5)
 738:	00e7e463          	bltu	a5,a4,740 <free+0x3a>
 73c:	00e6ea63          	bltu	a3,a4,750 <free+0x4a>
 740:	87ba                	mv	a5,a4
 742:	fed7fae3          	bgeu	a5,a3,736 <free+0x30>
 746:	6398                	ld	a4,0(a5)
 748:	00e6e463          	bltu	a3,a4,750 <free+0x4a>
 74c:	fee7eae3          	bltu	a5,a4,740 <free+0x3a>
 750:	ff852583          	lw	a1,-8(a0)
 754:	6390                	ld	a2,0(a5)
 756:	02059813          	slli	a6,a1,0x20
 75a:	01c85713          	srli	a4,a6,0x1c
 75e:	9736                	add	a4,a4,a3
 760:	fae60de3          	beq	a2,a4,71a <free+0x14>
 764:	fec53823          	sd	a2,-16(a0)
 768:	4790                	lw	a2,8(a5)
 76a:	02061593          	slli	a1,a2,0x20
 76e:	01c5d713          	srli	a4,a1,0x1c
 772:	973e                	add	a4,a4,a5
 774:	fae68ae3          	beq	a3,a4,728 <free+0x22>
 778:	e394                	sd	a3,0(a5)
 77a:	00000717          	auipc	a4,0x0
 77e:	60f73323          	sd	a5,1542(a4) # d80 <freep>
 782:	6422                	ld	s0,8(sp)
 784:	0141                	addi	sp,sp,16
 786:	8082                	ret

0000000000000788 <malloc>:
 788:	7139                	addi	sp,sp,-64
 78a:	fc06                	sd	ra,56(sp)
 78c:	f822                	sd	s0,48(sp)
 78e:	f426                	sd	s1,40(sp)
 790:	ec4e                	sd	s3,24(sp)
 792:	0080                	addi	s0,sp,64
 794:	02051493          	slli	s1,a0,0x20
 798:	9081                	srli	s1,s1,0x20
 79a:	04bd                	addi	s1,s1,15
 79c:	8091                	srli	s1,s1,0x4
 79e:	0014899b          	addiw	s3,s1,1
 7a2:	0485                	addi	s1,s1,1
 7a4:	00000517          	auipc	a0,0x0
 7a8:	5dc53503          	ld	a0,1500(a0) # d80 <freep>
 7ac:	c915                	beqz	a0,7e0 <malloc+0x58>
 7ae:	611c                	ld	a5,0(a0)
 7b0:	4798                	lw	a4,8(a5)
 7b2:	08977e63          	bgeu	a4,s1,84e <malloc+0xc6>
 7b6:	f04a                	sd	s2,32(sp)
 7b8:	e852                	sd	s4,16(sp)
 7ba:	e456                	sd	s5,8(sp)
 7bc:	e05a                	sd	s6,0(sp)
 7be:	8a4e                	mv	s4,s3
 7c0:	0009871b          	sext.w	a4,s3
 7c4:	6685                	lui	a3,0x1
 7c6:	00d77363          	bgeu	a4,a3,7cc <malloc+0x44>
 7ca:	6a05                	lui	s4,0x1
 7cc:	000a0b1b          	sext.w	s6,s4
 7d0:	004a1a1b          	slliw	s4,s4,0x4
 7d4:	00000917          	auipc	s2,0x0
 7d8:	5ac90913          	addi	s2,s2,1452 # d80 <freep>
 7dc:	5afd                	li	s5,-1
 7de:	a091                	j	822 <malloc+0x9a>
 7e0:	f04a                	sd	s2,32(sp)
 7e2:	e852                	sd	s4,16(sp)
 7e4:	e456                	sd	s5,8(sp)
 7e6:	e05a                	sd	s6,0(sp)
 7e8:	00000797          	auipc	a5,0x0
 7ec:	5a078793          	addi	a5,a5,1440 # d88 <base>
 7f0:	00000717          	auipc	a4,0x0
 7f4:	58f73823          	sd	a5,1424(a4) # d80 <freep>
 7f8:	e39c                	sd	a5,0(a5)
 7fa:	0007a423          	sw	zero,8(a5)
 7fe:	b7c1                	j	7be <malloc+0x36>
 800:	6398                	ld	a4,0(a5)
 802:	e118                	sd	a4,0(a0)
 804:	a08d                	j	866 <malloc+0xde>
 806:	01652423          	sw	s6,8(a0)
 80a:	0541                	addi	a0,a0,16
 80c:	00000097          	auipc	ra,0x0
 810:	efa080e7          	jalr	-262(ra) # 706 <free>
 814:	00093503          	ld	a0,0(s2)
 818:	c13d                	beqz	a0,87e <malloc+0xf6>
 81a:	611c                	ld	a5,0(a0)
 81c:	4798                	lw	a4,8(a5)
 81e:	02977463          	bgeu	a4,s1,846 <malloc+0xbe>
 822:	00093703          	ld	a4,0(s2)
 826:	853e                	mv	a0,a5
 828:	fef719e3          	bne	a4,a5,81a <malloc+0x92>
 82c:	8552                	mv	a0,s4
 82e:	00000097          	auipc	ra,0x0
 832:	bc2080e7          	jalr	-1086(ra) # 3f0 <sbrk>
 836:	fd5518e3          	bne	a0,s5,806 <malloc+0x7e>
 83a:	4501                	li	a0,0
 83c:	7902                	ld	s2,32(sp)
 83e:	6a42                	ld	s4,16(sp)
 840:	6aa2                	ld	s5,8(sp)
 842:	6b02                	ld	s6,0(sp)
 844:	a03d                	j	872 <malloc+0xea>
 846:	7902                	ld	s2,32(sp)
 848:	6a42                	ld	s4,16(sp)
 84a:	6aa2                	ld	s5,8(sp)
 84c:	6b02                	ld	s6,0(sp)
 84e:	fae489e3          	beq	s1,a4,800 <malloc+0x78>
 852:	4137073b          	subw	a4,a4,s3
 856:	c798                	sw	a4,8(a5)
 858:	02071693          	slli	a3,a4,0x20
 85c:	01c6d713          	srli	a4,a3,0x1c
 860:	97ba                	add	a5,a5,a4
 862:	0137a423          	sw	s3,8(a5)
 866:	00000717          	auipc	a4,0x0
 86a:	50a73d23          	sd	a0,1306(a4) # d80 <freep>
 86e:	01078513          	addi	a0,a5,16
 872:	70e2                	ld	ra,56(sp)
 874:	7442                	ld	s0,48(sp)
 876:	74a2                	ld	s1,40(sp)
 878:	69e2                	ld	s3,24(sp)
 87a:	6121                	addi	sp,sp,64
 87c:	8082                	ret
 87e:	7902                	ld	s2,32(sp)
 880:	6a42                	ld	s4,16(sp)
 882:	6aa2                	ld	s5,8(sp)
 884:	6b02                	ld	s6,0(sp)
 886:	b7f5                	j	872 <malloc+0xea>
