extends Reference
 
const RAND_MAX = 2147483648.0
 
var current_seed = -1
var current_state = current_seed
 
 
func randInt():
    var r = rand_seed(current_state)
    current_state = r[1]
    return abs(r[0])
 
 
func randFloat():
    return randInt() / RAND_MAX
 
 
func randRangeInt(lower, upper):
    if upper <= lower:
        return lower
   
    var range_value = int(upper - lower)+1
    return lower + (randInt() % range_value)
 
 
func randRangeFloat(lower, upper):
    if upper <= lower:
        return lower
   
    var range_value = upper - lower
    return lower + randFloat() * range_value
 
 
func randRollInt(lower, upper, clump):
    return int(randRollFloat(lower, upper, clump))
 
 
func randRollFloat(lower, upper, clump):
    if upper <= lower:
        return lower
   
    clump = int(max(clump, 1))
   
    var range_value = upper - lower
   
    var total = 0
    for i in clump:
        total += randFloat() * range_value * (1.0 / clump)
   
    return lower + total
 
 
func randBool(percentage):
    return randInt() < RAND_MAX * clamp(percentage, 0, 1)
 
 
func randArray(array):
    # arrays must be [weight, value]
   
    var sum_of_weights = 0
    for t in array:
        sum_of_weights += t[0]
   
    var x = randFloat() * sum_of_weights
   
    var cumulative_weight = 0
    for t in array:
        cumulative_weight += t[0]
       
        if x < cumulative_weight:
            return t[1]
 
func randDir():
	var d = randRangeInt(1,4)
	match d:
		1:
			return Vector2(-1,0)
		2:
			return Vector2(1,0)
		3:
			return Vector2(0,1)
		4:
			return Vector2(0,-1)
 
func setSeed(input):
    var new_seed = -1
   
    match typeof(input):
        TYPE_STRING:
            if input.is_valid_float():
                new_seed = input.to_float()
                continue
           
            var b = var2bytes(input)
           
            var total = 0
            for i in b.size():
                total += (1 << i) * b[i]
           
            new_seed = -total
       
        TYPE_INT, TYPE_REAL:
            new_seed = input
   
    current_seed = new_seed
    current_state = current_seed
 
 
func randomizeSeed():
    setSeed(OS.get_ticks_msec() * 4398046511104 + 4398046511104)