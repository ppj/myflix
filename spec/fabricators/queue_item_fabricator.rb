Fabricator(:queue_item) do
  position { sequence(:position, 1) }
  video
end
