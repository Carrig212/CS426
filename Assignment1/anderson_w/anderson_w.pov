#include "colors.inc"
#include "textures.inc"
                                                                    
light_source { 
  <0, 10, 0> 
  color White 
  spotlight 
}
                                                                    
camera { 
  location -<0, 0, 5> 
  look_at <0, 0, 0> 
  rotate <0, 45, 0> // Rotate the camera around the y axis on the clock pulse 
}

plane { 
  <0, 1, 0>, -0.1 
  pigment { checker White, Black } 
  translate -<0, 2, 0>  // Move the floor to be at the bottom of the wheel
}

#declare spoke_star = union {
  cylinder { -<2, 0, 0>, <2, 0, 0>, 0.015 pigment { Red } } // Horizontal   
  cylinder { -<0, 2, 0>, <0, 2, 0>, 0.015 pigment { Red } } // Vertical
  
  cylinder { <-1.4,  1.4, 0>, < 1.4, -1.4, 0>, 0.015 texture { New_Brass } } // Negative diagonal  
  cylinder { <-1.4, -1.4, 0>, < 1.4,  1.4, 0>, 0.015 texture { New_Brass } } // Positive diagonal  
}

#declare spoke_nipple_star = union {
  // Horizontal
  cylinder {  <2, 0, 0>,  <1.75, 0, 0>, 0.02 texture { Aluminum } } // Right
  cylinder { -<2, 0, 0>, -<1.75, 0, 0>, 0.02 texture { Aluminum } } // Left
  
  // Vertical
  cylinder {  <0, 2, 0>,  <0, 1.75, 0>, 0.02 texture { Aluminum } } // Top
  cylinder { -<0, 2, 0>, -<0, 1.75, 0>, 0.02 texture { Aluminum } } // Bottom
  
  // Negative diagonal                                                                                                
  cylinder {  <-1.4, 1.4, 0>,  <-1.23, 1.23, 0>, 0.02 texture { Aluminum } } // Top left
  cylinder { -<-1.4, 1.4, 0>, -<-1.23, 1.23, 0>, 0.02 texture { Aluminum } } // Bottom right                                                                                                  
  
  // Positive diagonal
  cylinder {  <1.4, 1.4, 0>,  <1.23, 1.23, 0>, 0.02 texture { Aluminum } } // Top right
  cylinder { -<1.4, 1.4, 0>, -<1.23, 1.23, 0>, 0.02 texture { Aluminum } } // Bottom left
  
}

// This allows me to copy the spokes and nipples together
#declare full_spoke_star = union {
  object { spoke_star        }
  object { spoke_nipple_star }
}

// This is a series of rotated full spoke stars which quadruples the number of spokes in the wheel 
#declare spokes = union {
  object { full_spoke_star                        } //  No   rotation
  object { full_spoke_star rotate  <0, 0, 22.25 > } //  1/8  rotation
  object { full_spoke_star rotate  <0, 0, 11.125> } //  1/16 rotation
  object { full_spoke_star rotate -<0, 0, 11.125> } // -1/16 rotation
  
  rotate -<0, 0, 5.5625> // Rotate the spokes so that they're in a nice looking position when they render
}                                          

// The hub is a cylinder with a truncated cone on either end  
#declare hub  = union { 
  cylinder { <0, 0, 0.05>, -<0, 0, 0.05>, 0.15 pigment { Gray10 } } // Middle
  
  cone {  <0, 0, 0.05>, 0.15,  <0, 0, 0.15>, 0.075 pigment { Gray20 } } // Back
  cone { -<0, 0, 0.05>, 0.15, -<0, 0, 0.15>, 0.075 pigment { Gray20 } } // Front
}
   
// The rim is just an open cylinder positioned on the inside of the tire
#declare rim  = cylinder { <0, 0, 0.05>, -<0, 0, 0.05> 1.85 open texture { New_Brass } }  

// The tire is just a plain ol' torus
#declare tire = torus { 2, 0.15 rotate <90, 0, 0> pigment { checker Gray10, Gray20 } }
             
// The valve is made of two stacked cylinders, the cap is slightly wider than the stem             
#declare valve = union {
  cylinder { -<2  , 0, 0>, -<1.75, 0, 0>, 0.03  pigment { Gray10 } } // Stem
  cylinder { -<1.7, 0, 0>, -<1.75, 0, 0>, 0.04  pigment { Gray20 } } // Cap
}

// This is the hole in the middle of the wheel
#declare hole = cylinder { <0, 0, 0.751>, -<0, 0, 0.751>, 0.035 }

// This is the whole wheel without the hole in the middle
#declare solid_wheel = union {
  object { hub    }
  object { rim    }
  object { spokes }
  object { tire   }
  object { valve  }
}

// Add the hole to the middle
#declare wheel = difference {
  object { solid_wheel }
  object { hole        }  
}
  
object { 
  wheel // Display the completed wheel
  rotate <0, 0, clock> // Rotate the wheel on the z axis at twice the clock pulse so it rotates fully twice
}