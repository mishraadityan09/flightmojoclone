import React, { useState, useEffect, useRef } from 'react';
import { X } from 'lucide-react';

const DatePickerModal = ({ 
  isOpen, 
  onClose, 
  initialDate, 
  onDateSelected, 
  prices = {} 
}) => {
  const [selectedDate, setSelectedDate] = useState(null);
  const [months, setMonths] = useState([]);
  const scrollContainerRef = useRef(null);

  // Initialize dates and months
  useEffect(() => {
    const now = new Date();
    const startDate = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const endDate = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 360);
    
    // Set initial selected date
    if (initialDate) {
      const normalized = new Date(initialDate.getFullYear(), initialDate.getMonth(), initialDate.getDate());
      setSelectedDate(normalized);
    } else {
      setSelectedDate(startDate);
    }
    
    // Generate months array
    const monthsList = [];
    const current = new Date(startDate.getFullYear(), startDate.getMonth(), 1);
    const end = new Date(endDate.getFullYear(), endDate.getMonth(), 1);
    
    while (current <= end) {
      monthsList.push(new Date(current));
      current.setMonth(current.getMonth() + 1);
    }
    
    setMonths(monthsList);
  }, [initialDate]);

  // Helper function to check if two dates are the same day
  const isSameDay = (date1, date2) => {
    if (!date1 || !date2) return false;
    return date1.getFullYear() === date2.getFullYear() &&
           date1.getMonth() === date2.getMonth() &&
           date1.getDate() === date2.getDate();
  };

  // Get price for a specific date
  const getPriceForDate = (date) => {
    const dateKey = `${date.getFullYear()}-${date.getMonth()}-${date.getDate()}`;
    return prices[dateKey] || null;
  };

  // Handle date selection
  const handleDateClick = (date) => {
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const maxDate = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 360);
    
    if (date >= today && date <= maxDate) {
      setSelectedDate(date);
    }
  };

  // Handle confirm selection
  const handleConfirm = () => {
    if (selectedDate && onDateSelected) {
      onDateSelected(selectedDate);
    }
    onClose();
  };

  // Build calendar month
  const buildCalendarMonth = (month) => {
    const firstDayOfMonth = new Date(month.getFullYear(), month.getMonth(), 1);
    const lastDayOfMonth = new Date(month.getFullYear(), month.getMonth() + 1, 0);
    const startingWeekday = firstDayOfMonth.getDay(); // 0 = Sunday
    const totalDays = lastDayOfMonth.getDate();
    
    const days = [];
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const maxDate = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 360);
    
    // Add empty cells for days before month starts
    for (let i = 0; i < startingWeekday; i++) {
      days.push(<div key={`empty-${i}`} className="h-12"></div>);
    }
    
    // Add day cells
    for (let day = 1; day <= totalDays; day++) {
      const date = new Date(month.getFullYear(), month.getMonth(), day);
      const isToday = isSameDay(date, today);
      const isSelected = isSameDay(date, selectedDate);
      const isDisabled = date < today || date > maxDate;
      const price = getPriceForDate(date);
      
      days.push(
        <div
          key={day}
          onClick={() => !isDisabled && handleDateClick(date)}
          className={`
            h-12 m-0.5 rounded-lg flex flex-col items-center justify-center cursor-pointer transition-colors
            ${isDisabled ? 'text-gray-300 cursor-not-allowed' : 'hover:bg-blue-50'}
            ${isSelected ? 'bg-blue-500 text-white' : ''}
            ${isToday && !isSelected ? 'border-2 border-blue-500 text-blue-500' : ''}
            ${!isSelected && !isToday && !isDisabled ? 'text-gray-900' : ''}
          `}
        >
          <span className={`text-sm ${isSelected || isToday ? 'font-bold' : 'font-normal'}`}>
            {day}
          </span>
          {price && (
            <span className={`text-xs ${isSelected ? 'text-white opacity-90' : 'text-gray-600'}`}>
              ${price}
            </span>
          )}
        </div>
      );
    }
    
    return days;
  };

  // Get month name
  const getMonthYearText = (date) => {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return `${months[date.getMonth()]} ${date.getFullYear()}`;
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-end justify-center z-50">
      <div className="bg-white rounded-t-3xl w-full max-w-md h-3/4 flex flex-col">
        {/* Header */}
        <div className="flex justify-between items-center p-4 border-b">
          <h2 className="text-xl font-bold">Select Date</h2>
          <button
            onClick={onClose}
            className="p-2 hover:bg-gray-100 rounded-full transition-colors"
          >
            <X size={20} />
          </button>
        </div>
        
        {/* Subtitle */}
        <div className="px-4 py-2 text-center">
          <h3 className="text-lg font-semibold">Select a Date</h3>
        </div>
        
        {/* Weekday headers */}
        <div className="px-4 grid grid-cols-7 gap-1">
          {['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'].map((day) => (
            <div key={day} className="text-center py-3 text-sm font-semibold text-gray-600">
              {day}
            </div>
          ))}
        </div>
        
        {/* Calendar months */}
        <div ref={scrollContainerRef} className="flex-1 overflow-y-auto px-4">
          {months.map((month, index) => (
            <div key={index} className="mb-4">
              {/* Month header */}
              <div className="py-4">
                <h4 className="text-lg font-bold text-blue-500">
                  {getMonthYearText(month)}
                </h4>
              </div>
              
              {/* Calendar grid */}
              <div className="grid grid-cols-7 gap-1">
                {buildCalendarMonth(month)}
              </div>
            </div>
          ))}
        </div>
        
        {/* Bottom buttons */}
        <div className="p-4 flex gap-4 border-t">
          <button
            onClick={onClose}
            className="flex-1 py-3 border border-gray-300 rounded-lg text-gray-700 font-medium hover:bg-gray-50 transition-colors"
          >
            Cancel
          </button>
          <button
            onClick={handleConfirm}
            className="flex-1 py-3 bg-blue-500 text-white rounded-lg font-medium hover:bg-blue-600 transition-colors"
          >
            Select
          </button>
        </div>
      </div>
    </div>
  );
};

// Main demo component
const DatePickerDemo = () => {
  const [isPickerOpen, setIsPickerOpen] = useState(false);
  const [selectedDate, setSelectedDate] = useState(null);
  
  // Sample price data
  const samplePrices = {
    '2025-6-25': 150,  // July 25th (month is 0-indexed in JavaScript)
    '2025-6-26': 175,  // July 26th
    '2025-6-27': 200,  // July 27th
    '2025-6-28': 125,  // July 28th
    '2025-6-29': 180,  // July 29th
    '2025-6-30': 165,  // July 30th
    '2025-7-1': 190,   // August 1st
    '2025-7-2': 220,   // August 2nd
    '2025-7-3': 175,   // August 3rd
    '2025-7-15': 300,  // August 15th - higher price
    '2025-7-16': 280,  // August 16th
    '2025-8-10': 250,  // September 10th
  };

  const handleDateSelected = (date) => {
    setSelectedDate(date);
    console.log('Selected date:', date);
  };

  const formatDate = (date) => {
    if (!date) return '';
    return date.toLocaleDateString('en-US', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric'
    });
  };

  const getSelectedPrice = () => {
    if (!selectedDate) return null;
    const dateKey = `${selectedDate.getFullYear()}-${selectedDate.getMonth()}-${selectedDate.getDate()}`;
    return samplePrices[dateKey];
  };

  return (
    <div className="p-8 max-w-md mx-auto">
      <div className="space-y-6">
        <h1 className="text-2xl font-bold text-center">React Date Picker Demo</h1>
        
        {/* Date selection button */}
        <button
          onClick={() => setIsPickerOpen(true)}
          className="w-full py-3 px-4 bg-blue-500 text-white rounded-lg font-medium hover:bg-blue-600 transition-colors"
        >
          {selectedDate ? `Selected: ${formatDate(selectedDate)}` : 'Select a Date'}
        </button>
        
        {/* Selected date info */}
        {selectedDate && (
          <div className="bg-gray-50 p-4 rounded-lg">
            <h3 className="font-semibold mb-2">Selection Details:</h3>
            <p><strong>Date:</strong> {formatDate(selectedDate)}</p>
            {getSelectedPrice() && (
              <p><strong>Price:</strong> ${getSelectedPrice()}</p>
            )}
          </div>
        )}
        
        {/* Instructions */}
        <div className="bg-blue-50 p-4 rounded-lg text-sm">
          <h4 className="font-semibold mb-2">Features:</h4>
          <ul className="space-y-1 text-gray-700">
            <li>• Scrollable calendar with multiple months</li>
            <li>• Price display below dates</li>
            <li>• Today's date highlighting</li>
            <li>• Selection state management</li>
            <li>• Disabled past dates</li>
            <li>• Mobile-friendly bottom sheet design</li>
          </ul>
        </div>
      </div>
      
      {/* Date picker modal */}
      <DatePickerModal
        isOpen={isPickerOpen}
        onClose={() => setIsPickerOpen(false)}
        initialDate={selectedDate}
        onDateSelected={handleDateSelected}
        prices={samplePrices}
      />
    </div>
  );
};

export default DatePickerDemo;