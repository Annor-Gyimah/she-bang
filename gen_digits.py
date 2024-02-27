from string import digits
import random

num = digits
rad = random.SystemRandom()
account_num = "".join(rad.choice(num) for i in range(10))
print(account_num)