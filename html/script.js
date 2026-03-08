// ===========================
// Garden Blog Data
// ===========================

const weekData = [
    {
        week: 1,
        date: "February 25, 2025",
        content: `
            <h3>Starting the Journey - Seed Preparation</h3>
            <p>This week marked the beginning of my 2025 garden! I'm starting with tomatoes since they need a 6-8 week head start before transplanting outdoors in mid-April.</p>
            
            <h3>Soil Mix Recipe</h3>
            <ul>
                <li>50% Coco coir (rinsed to remove salts)</li>
                <li>30% Perlite for drainage</li>
                <li>20% Worm castings for gentle nutrients</li>
            </ul>
            
            <h3>Seeds Started</h3>
            <ul>
                <li>Cherokee Purple tomatoes (6 cells)</li>
                <li>San Marzano tomatoes (6 cells)</li>
                <li>Cherry tomatoes - Sungold (4 cells)</li>
            </ul>
            
            <h3>Setup</h3>
            <p>Placed seed trays on a heat mat set to 75°F to encourage germination. Using LED grow lights on a 16-hour timer, positioned about 3 inches above the trays.</p>
            
            <h3>Next Week's Goals</h3>
            <ul>
                <li>Watch for germination (should be 5-10 days)</li>
                <li>Remove humidity dome once seeds sprout</li>
                <li>Keep soil moist but not waterlogged</li>
            </ul>
        `
    },
    {
        week: 2,
        date: "March 4, 2025",
        content: `
            <h3>First Sprouts! 🌱</h3>
            <p>After 7 days, I have sprouts! The Cherokee Purple were first (day 5), followed by San Marzano (day 6) and Sungold (day 7). Germination rate is about 85% - pretty good!</p>
            
            <h3>What Changed</h3>
            <ul>
                <li>Removed humidity domes once seedlings emerged</li>
                <li>Lowered heat mat temperature to 70°F</li>
                <li>Raised grow lights to 4 inches above seedlings</li>
                <li>Started bottom watering to prevent damping off</li>
            </ul>
            
            <h3>Observations</h3>
            <p>Seedlings are looking healthy with strong green cotyledons (seed leaves). No signs of stretching, which means the light intensity is good. Keeping a close eye on moisture levels - the coco coir mix drains well but I need to water every other day.</p>
            
            <h3>Planning Ahead</h3>
            <p>Started researching hardening off schedules. In about 4 weeks, I'll need to gradually introduce these babies to outdoor conditions before transplanting.</p>
        `
    },
    {
        week: 3,
        date: "March 11, 2025",
        content: `
            <h3>True Leaves Appearing</h3>
            <p>The seedlings are getting their first set of true leaves (the ones that look like actual tomato leaves, not the round seed leaves). This is an exciting milestone!</p>
            
            <h3>Feeding Schedule Started</h3>
            <p>Began feeding with diluted liquid fertilizer (1/4 strength) once a week. The worm castings in the soil mix provided nutrients for the first 2-3 weeks, but now the plants need more.</p>
            
            <h3>Garden Planning</h3>
            <p>Spent time planning the outdoor garden layout. I have a 10x10 raised bed and need to figure out spacing:</p>
            <ul>
                <li>Tomatoes: 24-36 inches apart (need to set up cages/stakes)</li>
                <li>Companion plants: Planning to add basil between tomatoes</li>
                <li>Succession planting: Making notes for beans and cucumbers to plant later</li>
            </ul>
            
            <h3>Weather Watch</h3>
            <p>Last frost date for Zone 7A is typically April 15-20. That's about 5 weeks away - perfect timing for these seedlings!</p>
        `
    }
];

// ===========================
// DOM Elements
// ===========================

const weekEntriesContainer = document.getElementById('week-entries');
const modal = document.getElementById('week-modal');
const modalBody = document.getElementById('modal-body');
const closeModal = document.querySelector('.close');
const weekCountElement = document.getElementById('week-count');
const plantCountElement = document.getElementById('plant-count');

// ===========================
// Initialize Page
// ===========================

document.addEventListener('DOMContentLoaded', () => {
    renderWeekCards();
    updateStats();
    setupEventListeners();
    setupSmoothScrolling();
});

// ===========================
// Render Week Cards
// ===========================

function renderWeekCards() {
    // Sort weeks in reverse order (newest first)
    const sortedWeeks = [...weekData].sort((a, b) => b.week - a.week);
    
    weekEntriesContainer.innerHTML = '';
    
    sortedWeeks.forEach(week => {
        const card = createWeekCard(week);
        weekEntriesContainer.appendChild(card);
    });
}

// ===========================
// Create Week Card
// ===========================

function createWeekCard(week) {
    const card = document.createElement('div');
    card.className = 'week-card';
    
    card.innerHTML = `
        <div class="week-number-large">Week ${week.week}</div>
        <div class="week-date">${week.date}</div>
    `;
    
    card.addEventListener('click', (e) => {
        e.preventDefault();
        openModal(week);
    });
    
    return card;
}

// ===========================
// Modal Functions
// ===========================

function openModal(week) {
    modalBody.innerHTML = `
        <div class="modal-week-header">
            <div class="modal-week-number">Week ${week.week}</div>
            <div class="modal-week-date">${week.date}</div>
        </div>
        <div class="modal-week-content">
            ${week.content}
        </div>
    `;
    
    modal.style.display = 'block';
    document.body.style.overflow = 'hidden'; // Prevent background scrolling
}

function closeModalFunc() {
    modal.style.display = 'none';
    document.body.style.overflow = 'auto';
}

// ===========================
// Update Stats
// ===========================

function updateStats() {
    const totalWeeks = weekData.length;
    const totalPlants = calculateTotalPlants();
    
    animateCounter(weekCountElement, 0, totalWeeks, 1000);
    animateCounter(plantCountElement, 0, totalPlants, 1500);
}

function calculateTotalPlants() {
    // You can update this based on your actual plant count
    // For now, calculating from Week 1 data
    return 16; // 6 + 6 + 4 from Cherokee Purple, San Marzano, and Sungold
}

function animateCounter(element, start, end, duration) {
    let startTime = null;
    
    function animation(currentTime) {
        if (!startTime) startTime = currentTime;
        const progress = Math.min((currentTime - startTime) / duration, 1);
        const value = Math.floor(progress * (end - start) + start);
        element.textContent = value;
        
        if (progress < 1) {
            requestAnimationFrame(animation);
        }
    }
    
    requestAnimationFrame(animation);
}

// ===========================
// Event Listeners
// ===========================

function setupEventListeners() {
    // Close modal when clicking the X
    closeModal.addEventListener('click', closeModalFunc);
    
    // Close modal when clicking outside
    window.addEventListener('click', (e) => {
        if (e.target === modal) {
            closeModalFunc();
        }
    });
    
    // Close modal with Escape key
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && modal.style.display === 'block') {
            closeModalFunc();
        }
    });
}

// ===========================
// Smooth Scrolling
// ===========================

function setupSmoothScrolling() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            const href = this.getAttribute('href');
            
            // Don't prevent default for modal links
            if (this.classList.contains('read-more')) {
                return;
            }
            
            e.preventDefault();
            
            const targetId = href.substring(1);
            const targetElement = document.getElementById(targetId);
            
            if (targetElement) {
                targetElement.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
                
                // Update active nav link
                updateActiveNav(href);
            }
        });
    });
}

function updateActiveNav(href) {
    document.querySelectorAll('nav a').forEach(link => {
        link.classList.remove('active');
        if (link.getAttribute('href') === href) {
            link.classList.add('active');
        }
    });
}

// ===========================
// Helper: Add New Week
// ===========================

// This function can be used to easily add new weeks
function addNewWeek(weekNumber, date, content) {
    const newWeek = {
        week: weekNumber,
        date: date,
        content: content
    };
    
    weekData.push(newWeek);
    renderWeekCards();
    updateStats();
}

// Example usage (uncomment and modify to add a new week):
/*
addNewWeek(
    4,
    "March 18, 2025",
    `
        <h3>Transplanting to Larger Pots</h3>
        <p>The tomato seedlings have outgrown their seed starting cells...</p>
        
        <h3>What I Did</h3>
        <ul>
            <li>Transplanted all seedlings to 4-inch pots</li>
            <li>Used same soil mix as before</li>
        </ul>
    `
);
*/