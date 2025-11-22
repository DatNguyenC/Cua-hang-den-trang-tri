// ===== ADMIN LAYOUT JAVASCRIPT =====

// Global functions
function toggleSidebar() {
    console.log('Toggle sidebar clicked'); // Debug
    const sidebar = document.querySelector('.pc-sidebar');
    const body = document.body;
    
    if (sidebar) {
        console.log('Sidebar found, toggling...'); // Debug
        
        // Add transition class
        body.classList.add('sidebar-transitioning');
        
        // Toggle sidebar
        sidebar.classList.toggle('sidebar-hidden');
        body.classList.toggle('sidebar-hidden');
        
        // Remove transition class after animation
        setTimeout(() => {
            body.classList.remove('sidebar-transitioning');
        }, 400);
        
        // Save state
        const isHidden = sidebar.classList.contains('sidebar-hidden');
        localStorage.setItem('sidebarHidden', isHidden);
        console.log('Sidebar hidden:', isHidden); // Debug
        
        // Add ripple effect to button
        const btn = document.getElementById('sidebarToggleBtn');
        if (btn) {
            btn.style.transform = 'scale(0.95)';
            setTimeout(() => {
                btn.style.transform = '';
            }, 150);
        }
    } else {
        console.log('Sidebar not found!'); // Debug
    }
}

function toggleUserMenu() {
    console.log('=== TOGGLE USER MENU CALLED ==='); // Debug
    
    const dropdown = document.getElementById('userDropdown');
    const userBtn = document.querySelector('.user-btn');
    
    console.log('Dropdown element:', dropdown); // Debug
    console.log('User button element:', userBtn); // Debug
    
    if (!dropdown) {
        console.error('Dropdown not found!');
        return;
    }
    
    if (!userBtn) {
        console.error('User button not found!');
        return;
    }
    
    const isOpen = dropdown.classList.contains('show');
    console.log('Current state - isOpen:', isOpen); // Debug
    
    if (isOpen) {
        dropdown.classList.remove('show');
        userBtn.classList.remove('active');
        userBtn.setAttribute('aria-expanded', 'false');
        console.log('Dropdown closed'); // Debug
    } else {
        dropdown.classList.add('show');
        userBtn.classList.add('active');
        userBtn.setAttribute('aria-expanded', 'true');
        
        // Adjust dropdown position to prevent overflow
        adjustDropdownPosition(dropdown, userBtn);
        
        console.log('Dropdown opened'); // Debug
    }
    
    console.log('Final dropdown classes:', dropdown.className); // Debug
    console.log('=== END TOGGLE USER MENU ==='); // Debug
}

function adjustDropdownPosition(dropdown, userBtn) {
    // Wait for dropdown to be visible
    setTimeout(() => {
        const dropdownRect = dropdown.getBoundingClientRect();
        const viewportWidth = window.innerWidth;
        const viewportHeight = window.innerHeight;
        
        // Check if dropdown overflows right edge
        if (dropdownRect.right > viewportWidth) {
            const overflow = dropdownRect.right - viewportWidth + 10; // 10px margin
            dropdown.style.right = (parseInt(getComputedStyle(dropdown).right) + overflow) + 'px';
            console.log('Adjusted dropdown position for right overflow'); // Debug
        }
        
        // Check if dropdown overflows bottom edge
        if (dropdownRect.bottom > viewportHeight) {
            dropdown.style.top = 'auto';
            dropdown.style.bottom = '100%';
            dropdown.style.marginTop = '0';
            dropdown.style.marginBottom = '8px';
            console.log('Adjusted dropdown position for bottom overflow'); // Debug
        }
    }, 10);
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('Admin layout JS loaded'); // Debug
    
    // Add event listener to sidebar toggle button
    const toggleBtn = document.getElementById('sidebarToggleBtn');
    if (toggleBtn) {
        // Remove any existing listeners
        toggleBtn.removeEventListener('click', toggleSidebar);
        
        // Add new listener
        toggleBtn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            toggleSidebar();
        });
        console.log('Toggle button event listener added'); // Debug
    } else {
        console.log('Toggle button not found!'); // Debug
        
        // Try to find it after a delay (in case it's loaded later)
        setTimeout(() => {
            const delayedToggleBtn = document.getElementById('sidebarToggleBtn');
            if (delayedToggleBtn) {
                delayedToggleBtn.addEventListener('click', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                    toggleSidebar();
                });
                console.log('Delayed toggle button event listener added'); // Debug
            }
        }, 500);
    }
    
    // Add event listener to user dropdown button
    function setupUserDropdown() {
        const userBtn = document.getElementById('userDropdownBtn') || document.querySelector('.user-btn');
        console.log('Looking for user button...', userBtn); // Debug
        
        if (userBtn) {
            // Remove existing listeners
            userBtn.removeEventListener('click', handleUserDropdownClick);
            
            // Add new listener
            userBtn.addEventListener('click', handleUserDropdownClick);
            console.log('User dropdown button event listener added'); // Debug
            return true;
        }
        return false;
    }
    
    function handleUserDropdownClick(e) {
        e.preventDefault();
        e.stopPropagation();
        console.log('User dropdown clicked'); // Debug
        toggleUserMenu();
    }
    
    // Try to setup user dropdown immediately
    if (!setupUserDropdown()) {
        console.log('User dropdown button not found, trying after delay...'); // Debug
        
        // Try multiple times with increasing delays
        setTimeout(() => setupUserDropdown(), 100);
        setTimeout(() => setupUserDropdown(), 500);
        setTimeout(() => setupUserDropdown(), 1000);
    }
    
    // Restore sidebar state
    const savedState = localStorage.getItem('sidebarHidden');
    if (savedState === 'true') {
        const sidebar = document.querySelector('.pc-sidebar');
        const body = document.body;
        if (sidebar) {
            sidebar.classList.add('sidebar-hidden');
            body.classList.add('sidebar-hidden');
            console.log('Sidebar state restored: hidden'); // Debug
        }
    }
    
    // Event delegation for user dropdown (fallback)
    document.addEventListener('click', function(e) {
        // Handle user dropdown click via event delegation
        const userBtn = e.target.closest('.user-btn');
        if (userBtn) {
            e.preventDefault();
            e.stopPropagation();
            console.log('User dropdown clicked via delegation'); // Debug
            toggleUserMenu();
            return;
        }
        
        // Close dropdown when clicking outside
        const dropdown = document.getElementById('userDropdown');
        const userBtn = document.querySelector('.user-btn');
        
        if (dropdown && userBtn && !userBtn.contains(e.target) && !dropdown.contains(e.target)) {
            dropdown.classList.remove('show');
            userBtn.classList.remove('active');
            userBtn.setAttribute('aria-expanded', 'false');
        }
        
        // Close sidebar on mobile when clicking outside
        const sidebar = document.querySelector('.pc-sidebar');
        const toggle = document.querySelector('.sidebar-toggle-btn');
        
        if (window.innerWidth <= 1024 && sidebar && toggle && 
            !sidebar.contains(e.target) && !toggle.contains(e.target)) {
            sidebar.classList.remove('active');
        }
    });
    
    // Keyboard navigation for dropdown
    document.addEventListener('keydown', function(e) {
        const dropdown = document.getElementById('userDropdown');
        const userBtn = document.querySelector('.user-btn');
        
        if (dropdown && dropdown.classList.contains('show')) {
            const menuItems = dropdown.querySelectorAll('.dropdown-item');
            const currentFocus = document.activeElement;
            const currentIndex = Array.from(menuItems).indexOf(currentFocus);
            
            switch(e.key) {
                case 'Escape':
                    dropdown.classList.remove('show');
                    userBtn.classList.remove('active');
                    userBtn.setAttribute('aria-expanded', 'false');
                    userBtn.focus();
                    e.preventDefault();
                    break;
                case 'ArrowDown':
                    e.preventDefault();
                    const nextIndex = currentIndex < menuItems.length - 1 ? currentIndex + 1 : 0;
                    menuItems[nextIndex].focus();
                    break;
                case 'ArrowUp':
                    e.preventDefault();
                    const prevIndex = currentIndex > 0 ? currentIndex - 1 : menuItems.length - 1;
                    menuItems[prevIndex].focus();
                    break;
            }
        }
    });
});

// Debug function
function debugElements() {
    console.log('=== DEBUG ELEMENTS ===');
    console.log('Sidebar toggle button:', document.getElementById('sidebarToggleBtn'));
    console.log('User dropdown button:', document.getElementById('userDropdownBtn'));
    console.log('User button (class):', document.querySelector('.user-btn'));
    console.log('User dropdown:', document.getElementById('userDropdown'));
    console.log('Sidebar:', document.querySelector('.pc-sidebar'));
    console.log('======================');
}

// Simple test function
function testDropdown() {
    console.log('=== TESTING DROPDOWN ===');
    const dropdown = document.getElementById('userDropdown');
    if (dropdown) {
        dropdown.style.display = 'block';
        dropdown.style.opacity = '1';
        dropdown.style.visibility = 'visible';
        dropdown.style.transform = 'translateY(0)';
        console.log('Dropdown forced to show');
    } else {
        console.log('Dropdown not found for test');
    }
}

// Make functions globally available
window.toggleSidebar = toggleSidebar;
window.toggleUserMenu = toggleUserMenu;
window.debugElements = debugElements;
window.testDropdown = testDropdown;

// Auto debug after 2 seconds
setTimeout(debugElements, 2000);