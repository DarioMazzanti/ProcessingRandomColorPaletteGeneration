// PALETTES GENERATION ALGORITHMS

/* 
 * RandomColorPaletteGeneration.pde
 * Author: Dario Mazzanti (darmaz@gmail.com), 2013, uploaded 2017
 * 
 * This pde file is based on the following references, plus some small personal additions. 
 * If you are the author of some of the content mentioned/used in this file 
 * and you are not comfortable with it, please don't hesitate to contact me.
 *
 */

// REFERENCES

// http://devmag.org.za/2012/07/29/how-to-choose-colours-procedurally-algorithms/
// http://martin.ankerl.com/2009/12/09/how-to-create-random-colors-programmatically/
// http://stackoverflow.com/questions/43044/algorithm-to-randomly-generate-an-aesthetically-pleasing-color-palette




//random offset
//calculates random offset for each rgb component

// really simple, similar colors

color RandomOffset(color input_col, float offset)
{
  float value = (red(input_col) + green(input_col) + blue(input_col))/3.0;
  float newValue = value + 2*random(1.0) * offset - offset;
  float valueRatio = newValue/value;
  
  return color(red(input_col)*valueRatio, green(input_col)*valueRatio, blue(input_col)*valueRatio);
}

color[] RandomOffsetPalette(color input_col, float offset, int _numColors)
{
  color[] _thePalette = new color[_numColors];
  
  for(int i = 0; i < _numColors; i++)
    _thePalette[i] = RandomOffset(input_col, offset);
    
  return _thePalette;
}

// triad mixing
// randomly mixing three colors to generate a palette.
// the greyControl value limits the contribution of one of the three colors
// when greyControl is equal to 1 it doesn't change contribution
color RandomMix(color color1, color color2, color color3, float greyControl)
{
   int randomIndex = int(random(2));

   float mixRatio1;
   float mixRatio2;
   float mixRatio3;
      
   if(randomIndex == 0)
     mixRatio1 = random(1.0)*greyControl;
   else
     mixRatio1 = random(1.0);
     
     
   if(randomIndex == 1)
     mixRatio2 = random(1.0)*greyControl;
   else
     mixRatio2 = random(1.0);
          
      if(randomIndex == 2)
     mixRatio3 = random(1.0)*greyControl;
   else
     mixRatio3 = random(1.0);

   float sum = mixRatio1 + mixRatio2 + mixRatio3;

   mixRatio1 /= sum;
   mixRatio2 /= sum;
   mixRatio3 /= sum;

   color theColor = color(mixRatio1 * red(color1) + mixRatio2 * red(color2) + mixRatio3 * red(color3),
                         mixRatio1 * green(color1) + mixRatio2 * green(color2) + mixRatio3 * green(color3),
                         mixRatio1 * blue(color1) + mixRatio2 * blue(color2) + mixRatio3 * blue(color3));

  return theColor;
}


color[] RandomMixPalette(color color1, color color2, color color3, float greyControl, int _numColors)
{
  color[] _thePalette = new color[_numColors];
  
  for(int i = 0; i < _numColors; i++)
    _thePalette[i] = RandomMix(color1, color2, color3, greyControl);
    
  return _thePalette;
}


// average the RGB values of random colors with those of a constant color

// hints: mixing with white (255, 255, 255) creates pastel-like colors
// mixing with a constant color creates a tinted set of neutral colors
color RandomColorAverage(color inputColor)
{
  float r = int(random(255));
  float g = int(random(255));
  float b = int(random(255));
  
  r = (r + red(inputColor))/2;
  g = (g + green(inputColor))/2;
  b = (b + blue(inputColor))/2;

  
  return color(r, g, b);
}


color[] RandomColorAveragePalette(color inputColor, int _numColors)
{
  color[] _thePalette = new color[_numColors];
  
  for(int i = 0; i < _numColors; i++)
    _thePalette[i] = RandomColorAverage(inputColor);
    
  return _thePalette;
}


// H, S, B values 0.0 - 1.0, try to use it  constant s and b, varying h.
// returns a processing RGB color
color HSBtoRGB(float _h, float _s, float _b)
{
  
  int h_i = int(_h*6);
  float f = _h*6 - h_i;
  float p = _b*(1 - _s);
  float q = _b*(1 - f*_s);
  float t = _b*(1 - (1 - f)*_s);
  
  float r, g, b;
  
  if(h_i == 0)
  {
    r = _b;
    g = t;
    b = p;
  }
  
  else if(h_i == 1)
  {
    r = q;
    g = _b;
    b = p;
  }
  
  else if(h_i == 2)
  {
    r = p;
    g = _b;
    b = t;
  }
  
  else if(h_i == 3)
  {
    r = p;
    g = q;
    b = _b;
  }
  
  else if(h_i == 4)
  {
    r = t;
    g = p;
    b = _b;
  }
  
  else
  {
    r = _b;
    g = p;
    b = q;
  }

  return color(r*255, g*255, b*255);
}

// generates colors based on hsb space and on golden ratio
color[] RandomHueGoldenRatioPalette(float _saturation, float _brigthness, int _numColors)
{
  float random_hue = random(1.0);
  float golden_ratio_conjugate = 0.618033988749895;

  color[] _thePalette = new color[_numColors];
  
  for(int i = 0; i < _numColors; i++)
  {
      random_hue += golden_ratio_conjugate;
      random_hue%=1.0;
      
    _thePalette[i] = HSBtoRGB(random_hue, _saturation, _brigthness);
  }
    
  return _thePalette;
}




//The algorithm takes a few parameters; the important ones are two offset angles, and two angle ranges.

//The simplest form of the algorithm works as follows:

//Select a random reference angle.
//Select a random angle in the total of the range (the three range angles added together)
//If the angle is smaller than the first range, keep it
//Otherwise, if the angle is bigger than the first range, but smaller than the sum of the first Two ranges, offset it by the first offset angle
//Otherwise, offset it by the second offset angle
//Add this angle to the reference angle
//The colour with this angle as hue is a colour generated with the triad harmony

color[] GenerateColors_Harmony(int colorNum, 
  float offsetAngle1, float offsetAngle2, 
  float rangeAngle0, float rangeAngle1, float rangeAngle2, 
  float saturation, float luminance)
{
  color[] theColors = new color[colorNum];
  
  float referenceAngle = random(360.0);
  
  for(int i = 0; i < colorNum; i++)
  {
    float randomAngle = random(1.0)*(rangeAngle0 +  rangeAngle1 + rangeAngle2);
    
    if(randomAngle > rangeAngle0)
    {
      if(randomAngle < rangeAngle0 + rangeAngle1)
      {
        randomAngle += offsetAngle1;
      }
      else
      {
        randomAngle += offsetAngle2;
      }
    }
    
    
    theColors[i] = HSBtoRGB(((referenceAngle + randomAngle) / 360.0f) % 1.0f, saturation, luminance);
    
  }

  return theColors;
}




// same as before, but centering the reference and offset angles in corresponding ranges
/*With the centred version of the algorithm, it is easy to supply (instead of generating) the reference angle, making it possible to chain the algorithm with other colour selection algorithms.
More variety can be added by selecting random saturation and random luminance (possibly within a range from given parameters). This can potentially change the harmonic scheme by fringe colours being emphasized by their saturation / luminance. In many cases this is ok.
The hue can be selected uniformly instead of randomly across the total range. This will insure colours are a minimum hue-distance apart.
With suitable parameters, we can generate common colour schemes:
Analogous: Choose second and third ranges 0.
Complementary: Choose the third range 0, and first offset angle 180.
Split Complementary: Choose offset angles 180 +/- a small angle. The second and third ranges must be smaller than the difference between the two offset angles.
Triad: Choose offset angles 120 and 240.*/

color[] GenerateColors_Harmony_Centered(int colorNum, 
  float offsetAngle1, float offsetAngle2, 
  float rangeAngle0, float rangeAngle1, float rangeAngle2, 
  float saturation, float luminance)
{
  color[] theColors = new color[colorNum];
  
  float referenceAngle = random(360.0);
  
  for(int i = 0; i < colorNum; i++)
  {
    float randomAngle = random(1.0)*(rangeAngle0 +  rangeAngle1 + rangeAngle2);
    
    if(randomAngle > rangeAngle0)
    {
      if(randomAngle < rangeAngle0 + rangeAngle1)
      {
        randomAngle += (offsetAngle1 - rangeAngle1);
      }
      else
      {
        randomAngle += (offsetAngle2 - rangeAngle2);
      }
    }
    
    else
    {
      randomAngle -= rangeAngle0/2;
    }
    
    
    theColors[i] = HSBtoRGB(((referenceAngle + randomAngle) / 360.0f) % 1.0f, saturation, luminance);
    
  }
  
  
  return theColors;
}


color[] MyRandomColors(color _inputCol, int _numColors)
{
  color[] _thePalette = new color[_numColors];
  
  for(int i = 0; i < _numColors; i++)
    _thePalette[i] = color(red(_inputCol) - random(255), green(_inputCol) - random(255) , blue(_inputCol) - random(255));
    
  return _thePalette;
}


color[] ReallyRandomPalette(int _numColors)
{

  color[] _thePalette = new color[_numColors];
  
  for(int i = 0; i < _numColors; i++)
    _thePalette[i] = color(random(255), random(255), random(255));
    
  return _thePalette;
}
