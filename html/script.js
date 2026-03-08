// ===========================
// Garden Blog Data
// ===========================

const weekData = [
    {
        week: 1,
        date: "March 7th, 2026",
        content: `
            <h3>Cherry tomato - Seed Preparation</h3>
            <p>I'm starting with tomatoes since they need a 6-8 week head start before transplanting outdoors in mid-April (Early May?).</p>
            
            <h3>The soil mix I used</h3>
            <ul>
                <li>70% Coco coir</li>
                <li>20% Perlite for drainage</li>
                <li>10% Worm castings for gentle nutrients</li>
            </ul>
            
            <h3>What I planted</h3>
            <ul>
                <li>'Red Cherry' tomatoes (37 cells)</li>
            </ul>
            
            <h3>Setup</h3>
            <p>Placed seed trays on a heat mat set to 75°F to encourage germination.</p>
        `
        ////////////////
        ,date: "March 10th, 2026",
        content: `
            <h3>Cherry tomato - Seed Preparation</h3>
            <p>I'm starting with tomatoes since they need a 6-8 week head start before transplanting outdoors in mid-April (Early May?).</p>
            
            <h3>The soil mix I used</h3>
            <ul>
                <li>70% Coco coir</li>
                <li>20% Perlite for drainage</li>
                <li>10% Worm castings for gentle nutrients</li>
            </ul>
            
            <h3>What I planted</h3>
            <ul>
                <li>'Red Cherry' tomatoes (37 cells)</li>
            </ul>
            
            <h3>Setup</h3>
            <p>Placed seed trays on a heat mat set to 75°F to encourage germination.</p>
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