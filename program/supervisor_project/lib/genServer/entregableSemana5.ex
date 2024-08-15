defmodule ContadorControlador do
  use GenServer

  # API

  @doc """
  Inicia el proceso de contador y controlador usando GenServer.
  """
  def start_link do
    GenServer.start_link(__MODULE__, 0, name: __MODULE__)
  end

  @doc """
  Incrementa el contador y envía el valor al proceso controlador.
  """
  def increment do
    GenServer.cast(__MODULE__, :increment)
  end

  @doc """
  Obtiene el valor actual del contador.
  """
  def get_value do
    GenServer.call(__MODULE__, :get_value)
  end

  # Callbacks de GenServer

  @impl true
  def init(initial_value) do
    schedule_increment()  # Programar la primera operación de incremento
    {:ok, initial_value}
  end

  @impl true
  def handle_cast(:increment, value) do
    new_value = value + 1
    IO.puts("Valor del contador: #{new_value}")
    schedule_increment()  # Programar el siguiente incremento
    {:noreply, new_value}
  end

  @impl true
  def handle_call(:get_value, _from, value) do
    {:reply, value, value}
  end

  # Maneja cualquier mensaje inesperado
  @impl true
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  # Función auxiliar para programar la siguiente operación de incremento
  defp schedule_increment do
    Process.send_after(self(), :increment, 1000)  # Envía el mensaje :increment después de 1 segundo
  end
end

# Se inicia el servidor
{:ok, pid} = ContadorControlador.start_link()

# Para obtener el valor actual del contador en cualquier momento se ejecuta "ContadorControlador.get_value()"
IO.puts("Valor actual del contador: #{ContadorControlador.get_value()}")
