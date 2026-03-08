# 🌱 Garden Blog Website

A beautiful, responsive garden journal website to document your weekly gardening progress.

## Features

- **Weekly Journal Entries** - Document your garden progress week by week
- **Modal Popups** - Click any week card to see full details
- **Responsive Design** - Works on desktop, tablet, and mobile
- **Smooth Animations** - Beautiful fade-in effects and transitions
- **Garden-Themed Colors** - Earthy green and cream color palette
- **Easy to Update** - Simple JavaScript array to add new weeks

## Files Included

- `index.html` - Main HTML structure
- `styles.css` - All styling and responsive design
- `script.js` - JavaScript for dynamic content and interactions

## How to Use

### 1. Open the Website

Simply open `index.html` in your web browser. No server required!

### 2. Add New Weekly Entries

Edit the `weekData` array in `script.js`:

```javascript
const weekData = [
    {
        week: 4,  // Week number
        date: "March 18, 2025",  // Date
        title: "Your Week Title",  // Short title
        summary: "A brief summary of what happened this week...",  // Card preview
        content: `
            <h3>Section Title</h3>
            <p>Your detailed content here...</p>
            
            <h3>Another Section</h3>
            <ul>
                <li>Bullet point 1</li>
                <li>Bullet point 2</li>
            </ul>
        `,  // Full HTML content for modal
        tags: ["Tomatoes", "Watering", "Fertilizing"]  // Tag keywords
    },
    // Add more weeks here...
];
```

### 3. Customize

**Colors** - Edit CSS variables in `styles.css`:
```css
:root {
    --primary-green: #2d5016;
    --secondary-green: #4a7c2f;
    /* Change these to your preferred colors */
}
```

**Zone** - Change "Zone 7A" in `index.html` to your growing zone

**Stats** - Update the `calculateTotalPlants()` function in `script.js`

## Features Explained

### Week Cards
- Display week number, date, title, and summary
- Hover effect for interaction
- Tags for categorization
- Click to open detailed modal

### Modal Popup
- Shows full week entry content
- Supports HTML formatting (headings, lists, paragraphs)
- Close with X button, clicking outside, or ESC key

### Statistics
- Animated counters show weeks growing and plants started
- Updates automatically based on week data

## Tips for Adding Content

### Good Week Entry Structure:
```
1. What I Did This Week (overview)
2. Specific Activities (planting, watering, etc.)
3. Observations (what's working/not working)
4. Photos/Measurements (optional)
5. Next Week's Goals
```

### HTML Formatting in Content:
- `<h3>` for section headings
- `<p>` for paragraphs
- `<ul>` and `<li>` for bullet lists
- `<strong>` for bold text
- `<em>` for italic text

### Recommended Tags:
- Plant types: "Tomatoes", "Peppers", "Lettuce"
- Activities: "Seed Starting", "Transplanting", "Harvesting"
- Topics: "Soil", "Watering", "Pests", "Fertilizing"

## Browser Compatibility

Works on all modern browsers:
- Chrome
- Firefox
- Safari
- Edge

## Mobile Responsive

The design automatically adjusts for:
- Desktop (1200px+)
- Tablet (768px - 1199px)
- Mobile (< 768px)

## Future Enhancements

Ideas for extending this site:
- Add photo galleries for each week
- Search/filter by tags
- Export to PDF
- Connect to a backend database
- Add weather tracking
- Include planting calendar

## License

Free to use and modify for your personal garden blog!

---

Happy Gardening! 🌿🍅🌻
