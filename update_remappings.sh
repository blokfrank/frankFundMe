#!/bin/bash
echo "📦 Updating remappings..."
forge remappings > remappings.txt
if [ $? -eq 0 ]; then
  echo "✅ remappings.txt updated successfully."
else
  echo "❌ Failed to update remappings."
fi

