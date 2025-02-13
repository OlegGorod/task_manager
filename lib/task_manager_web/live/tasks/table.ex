# defmodule TaskManagerWeb.Tasks.Table do
#   use Phoenix.Component

#   @doc "Renders a table with given columns and rows"
#   attr :columns, :list, required: true
#   attr :rows, :list, required: true

#   def table(assigns) do
#     ~H"""
#     <table class="min-w-full border-collapse border border-gray-300">
#       <thead>
#         <tr class="bg-gray-100">
#           <%= for column <- @columns do %>
#             <th class="border border-gray-300 px-4 py-2"><%= column.label %></th>
#           <% end %>
#         </tr>
#       </thead>
#       <tbody>
#         <%= for row <- @rows do %>
#           <tr class="hover:bg-gray-50">
#             <%= for column <- @columns do %>
#               <td class="border border-gray-300 px-4 py-2"><%= Map.get(row, column.key) %></td>
#             <% end %>
#           </tr>
#         <% end %>
#       </tbody>
#     </table>
#     """
#   end
# end
