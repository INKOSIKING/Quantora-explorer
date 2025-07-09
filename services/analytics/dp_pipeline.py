from diffprivlib.mechanisms import Laplace

def dp_sum(data, epsilon=1.0):
    mech = Laplace(epsilon=epsilon, sensitivity=1)
    noisy_sum = mech.randomise(sum(data))
    return noisy_sum

# Example usage:
# result = dp_sum([1,2,3,4,5])