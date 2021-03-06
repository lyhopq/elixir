defmodule Integer do
  @moduledoc """
  Functions for working with integers.
  """

  import Bitwise

  @doc """
  Determines if an integer is odd.

  Returns `true` if `n` is an odd number, otherwise `false`.

  Allowed in guard clauses.
  """
  defmacro is_odd(n) do
    quote do: (unquote(n) &&& 1) == 1
  end

  @doc """
  Determines if an integer is even.

  Returns `true` if `n` is an even number, otherwise `false`.

  Allowed in guard clauses.
  """
  defmacro is_even(n) do
    quote do: (unquote(n) &&& 1) == 0
  end

  @doc """
  Returns the ordered digits for the given non-negative integer.

  An optional base value may be provided representing the radix for the returned
  digits.

  ## Examples

      iex> Integer.digits(101)
      [1, 0, 1]

      iex> Integer.digits(58127, 2)
      [1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1]

  """
  @spec digits(non_neg_integer, non_neg_integer) :: [non_neg_integer]
  def digits(n, base \\ 10) when is_integer(n)    and n >= 0
                            and  is_integer(base) and base >= 2 do
    do_digits(n, base, [])
  end

  defp do_digits(0, _base, []),  do: [0]
  defp do_digits(0, _base, acc), do: acc
  defp do_digits(n, base, acc)  do
    do_digits div(n,base), base, [rem(n,base) | acc]
  end

  @doc """
  Returns the integer represented by the ordered digits.

  An optional base value may be provided representing the radix for the digits.

   ## Examples

       iex> Integer.undigits([1, 0, 1])
       101

       iex> Integer.undigits([1, 4], 16)
       20
  """
  @spec undigits([integer], integer) :: integer
  def undigits(digits, base \\ 10) when is_integer(base) do
    do_undigits(digits, base, 0)
  end

  defp do_undigits([], _base, acc), do: acc
  defp do_undigits([digit | tail], base, acc) do
    do_undigits(tail, base, acc * base + digit)
  end

  @doc """
  Converts a binary to an integer.

  If successful, returns a tuple of the form `{integer, remainder_of_binary}`.
  Otherwise `:error`.

  ## Examples

      iex> Integer.parse("34")
      {34,""}

      iex> Integer.parse("34.5")
      {34,".5"}

      iex> Integer.parse("three")
      :error

  """
  @spec parse(binary) :: {integer, binary} | :error
  def parse(<< ?-, bin :: binary >>) do
    case do_parse(bin) do
      :error -> :error
      {number, remainder} -> {-number, remainder}
    end
  end

  def parse(<< ?+, bin :: binary >>) do
    do_parse(bin)
  end

  def parse(bin) when is_binary(bin) do
    do_parse(bin)
  end

  defp do_parse(<< char, bin :: binary >>) when char in ?0..?9, do: do_parse(bin, char - ?0)
  defp do_parse(_), do: :error

  defp do_parse(<< char, rest :: binary >>, acc) when char in ?0..?9 do
    do_parse rest, 10 * acc + (char - ?0)
  end

  defp do_parse(bitstring, acc) do
    {acc, bitstring}
  end

  @doc """
  Returns a binary which corresponds to the text representation
  of `some_integer`.

  Inlined by the compiler.

  ## Examples

      iex> Integer.to_string(123)
      "123"

  """
  @spec to_string(integer) :: String.t
  def to_string(some_integer) do
    :erlang.integer_to_binary(some_integer)
  end

  @doc """
  Returns a binary which corresponds to the text representation
  of `some_integer` in base `base`.

  Inlined by the compiler.

  ## Examples

      iex> Integer.to_string(100, 16)
      "64"

  """
  @spec to_string(integer, 2..36) :: String.t
  def to_string(some_integer, base) do
    :erlang.integer_to_binary(some_integer, base)
  end

  @doc """
  Returns a char list which corresponds to the text representation of the given integer.

  Inlined by the compiler.

  ## Examples

      iex> Integer.to_char_list(7)
      '7'

  """
  @spec to_char_list(integer) :: char_list
  def to_char_list(number) do
    :erlang.integer_to_list(number)
  end

  @doc """
  Returns a char list which corresponds to the text representation of the
  given integer in the given base.

  Inlined by the compiler.

  ## Examples

      iex> Integer.to_char_list(1023, 16)
      '3FF'

  """
  @spec to_char_list(integer, 2..36) :: char_list
  def to_char_list(number, base) do
    :erlang.integer_to_list(number, base)
  end
end
