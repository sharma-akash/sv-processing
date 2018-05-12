interface SeedOperation {
    int operation(int a, int b);
}

private int operate(int a, int b, SeedOperation g)
{
    return g.operation(a, b);
}

ArrayList<Float> noiseLine(float x, float xi, float n, int w)
{
  ArrayList<Float> d = new ArrayList<Float>(0);
  int i = 0;
  while (x<n)
  {
    d.add(noise(x));
    x+=xi;
    i++;
  }

  return d;
}
