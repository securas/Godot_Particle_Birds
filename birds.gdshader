// NOTE: Shader automatically converted from Godot Engine 4.2.2.stable's ParticleProcessMaterial.

shader_type particles;


uniform vec2 repel_pos = vec2( 200.0, 150.0 );
uniform float range = 64.0;

float rand_from_seed(inout uint seed) {
	int k;
	int s = int(seed);
	if (s == 0)
	s = 305420679;
	k = s / 127773;
	s = 16807 * (s - k * 127773) - 2836 * k;
	if (s < 0)
		s += 2147483647;
	seed = uint(s);
	return float(seed % uint(65536)) / 65535.0;
}

uint hash(uint x) {
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = ((x >> uint(16)) ^ x) * uint(73244475);
	x = (x >> uint(16)) ^ x;
	return x;
}


float get_frame( float t )
{
	float a = ( 0.5 - abs( fract( t ) - 0.5 ) ) * 2.0; // triangle function between 0 and 1
	return ( 24.0 + a * 3.0 ) / 27.0;
}

vec2 get_position( float t )
{
	return vec2( 
		sin( t * PI * 201423.123421234 ) * 320.0 + 320.0, 
		sin( t * PI * 1001.23424 ) * 180.0 + 180.0 );
}


void start() {
	uint base_number = NUMBER;
	uint alt_seed = hash(base_number + uint(1) + RANDOM_SEED);
	
	TRANSFORM[0].x = -1.0;
	TRANSFORM[3].xy = vec2( 0.0 );
	//TRANSFORM[3].xy = vec2( 0.0 ) + vec2( rand_from_seed( alt_seed ) * 10.0, rand_from_seed( alt_seed ) * 10.0 );
	//TRANSFORM[3].xy = get_position( rand_from_seed( alt_seed ) );
	VELOCITY *= 0.0;
	CUSTOM.z = 24.0 / 27.0;
	
	CUSTOM.x = rand_from_seed( alt_seed ) * 10.0;
	CUSTOM.y = rand_from_seed( alt_seed ) * 10000.0;
	
}

void process() 
{
	uint base_number = NUMBER;
//	if (repeatable){
//		base_number = INDEX;
//	}
	uint alt_seed = hash(base_number + uint(1) + RANDOM_SEED);
	
	
	CUSTOM.z = get_frame( TIME * 3.0 );
	
	
	// calculate 
	vec2 target_position = get_position( CUSTOM.y );
	vec2 dist = target_position - TRANSFORM[3].xy;
	float distlen = length( dist );
	vec2 desired_velocity = normalize( dist ) * 50.0;
	vec2 force = desired_velocity - VELOCITY.xy;
	
	vec2 dist_repel = repel_pos - TRANSFORM[3].xy;
	float dist_repel_len = length( dist_repel );
	vec2 repel_force = normalize( dist_repel ) * ( 1.0 / ( dist_repel_len + 1.0 ) * 6400.0 );
	if( dist_repel_len < range )
	{
		force -= repel_force;
	}
	
	VELOCITY.xy += force * DELTA;
	
	CUSTOM.x -= DELTA;
	if( CUSTOM.x <= 0.0 || distlen < 5.0 )
	{
		CUSTOM.x = rand_from_seed( alt_seed ) * 10.0;
		CUSTOM.y = TIME + rand_from_seed( alt_seed ) * 1000.0;
	}
	
	if( abs( VELOCITY.x ) > 0.0 )
	{
		TRANSFORM[0].x = -sign( VELOCITY.x );
	}
}




