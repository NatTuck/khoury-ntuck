defmodule Primes do
  def stream() do
    aa = [2, 3, 5, 7]
    bb = Stream.iterate(8, &(1+&1))
    |> Stream.filter(&is_prime?/1)
    Stream.concat(aa, bb)
  end

  def is_prime?(x) do
    Stream.take_while(stream(), &(&1 <= :math.sqrt(x)))
    |> Enum.all?(&(rem(x, &1) != 0))
  end

  def prime(k) do
    Enum.at(stream(), k)
  end
end
