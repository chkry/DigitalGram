#!/usr/bin/env python3
"""
Generate app icon images for DigitalGram with a book icon design
"""

from PIL import Image, ImageDraw
import os

def create_book_icon(size):
    """Create a book icon with the given size"""
    # Create image with transparency
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Calculate dimensions
    padding = size * 0.15
    book_width = size - (2 * padding)
    book_height = size - (2 * padding)
    
    # Book coordinates
    left = padding
    top = padding
    right = left + book_width
    bottom = top + book_height
    
    # Book colors - blue gradient
    book_color = (52, 120, 246)  # SF Blue
    spine_color = (40, 100, 220)
    page_color = (245, 245, 250)
    
    # Draw book shadow (offset slightly)
    shadow_offset = size * 0.02
    shadow_color = (0, 0, 0, 60)
    draw.rounded_rectangle(
        [left + shadow_offset, top + shadow_offset, right + shadow_offset, bottom + shadow_offset],
        radius=size * 0.08,
        fill=shadow_color
    )
    
    # Draw main book body
    draw.rounded_rectangle(
        [left, top, right, bottom],
        radius=size * 0.08,
        fill=book_color
    )
    
    # Draw book spine (left edge)
    spine_width = book_width * 0.15
    draw.rounded_rectangle(
        [left, top, left + spine_width, bottom],
        radius=size * 0.08,
        fill=spine_color
    )
    
    # Draw pages (right side, slightly inset)
    page_inset = size * 0.03
    page_left = left + spine_width + page_inset
    page_right = right - page_inset
    page_top = top + page_inset
    page_bottom = bottom - page_inset
    
    # Multiple page layers for depth
    for i in range(3):
        offset = i * (size * 0.01)
        draw.rounded_rectangle(
            [page_left - offset, page_top + offset, page_right - offset, page_bottom],
            radius=size * 0.05,
            fill=page_color
        )
    
    # Draw bookmark ribbon
    bookmark_width = book_width * 0.08
    bookmark_left = left + (book_width / 2) - (bookmark_width / 2)
    bookmark_color = (255, 149, 0)  # SF Orange
    draw.rectangle(
        [bookmark_left, top, bookmark_left + bookmark_width, top + (book_height * 0.4)],
        fill=bookmark_color
    )
    
    return img

def main():
    """Generate all required icon sizes"""
    # Define required sizes for macOS app icons
    sizes = [16, 32, 64, 128, 256, 512, 1024]
    
    output_dir = 'DigitalGram/Assets.xcassets/AppIcon.appiconset'
    os.makedirs(output_dir, exist_ok=True)
    
    for size in sizes:
        print(f"Generating {size}x{size} icon...")
        icon = create_book_icon(size)
        
        # Save 1x version
        filename = f'icon_{size}x{size}.png'
        icon.save(os.path.join(output_dir, filename), 'PNG')
        
        # For retina displays, also save @2x version (except 1024)
        if size <= 512:
            retina_size = size * 2
            print(f"Generating {size}x{size}@2x ({retina_size}x{retina_size}) icon...")
            retina_icon = create_book_icon(retina_size)
            retina_filename = f'icon_{size}x{size}@2x.png'
            retina_icon.save(os.path.join(output_dir, retina_filename), 'PNG')
    
    print("\nIcon generation complete!")
    print(f"Icons saved to: {output_dir}")

if __name__ == '__main__':
    main()
