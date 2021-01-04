int key_1 = 9033205
int key_2 = 9281649

def getLoopsize(int key) {
	int loopSize = 0
	int value = 1
	while (value != key) {
		value = (value * 7 ) % 20201227
		loopSize++
	}
	return loopSize
}

int key_1_loop = getLoopsize(key_1)
int key_2_loop = getLoopsize(key_2)

BigInteger key_1_B = new BigInteger("${key_1}")
BigInteger key_2_loop_B = new BigInteger("${key_2_loop}")
BigInteger key_mod_B = new BigInteger("20201227")
long result = key_1_B.modPow(key_2_loop_B,key_mod_B)

println "Stage #1: ${result}"
