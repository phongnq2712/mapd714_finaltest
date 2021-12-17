/**
 * Final Test
 * File Name:    BMI.swift
 * Author:         Quoc Phong Ngo
 * Student ID:   301148406
 * Version:        1.0
 * Date Modified:   December 17th, 2021
 */
   
import Foundation

class BMI
{
    private var m_id: String
    private var m_name: String
    private var m_age: Int
    private var m_height: Double
    private var m_weight: Double
    private var m_category: String
    private var m_mode: String
    private var m_date: String
    
    // public properties
    public var name: String
    {
        get
        {
            return m_name
        }
        
        set(newName)
        {
            m_name = newName
        }
    }
    
    public var age: Int
    {
        get
        {
            return m_age
        }
        
        set(newAge)
        {
            m_age = newAge
        }
    }
    
    public var height: Double
    {
        get
        {
            return m_height
        }
        
        set(newHeight)
        {
            m_height = newHeight
        }
    }
    
    public var weight: Double
    {
        get
        {
            return m_weight
        }
        set(newWeight)
        {
            m_weight = newWeight
        }
    }
    
    public var category: String
    {
        get
        {
            return m_category
        }
        
        set(newCategory)
        {
            m_category = newCategory
        }
    }
    
    public var mode: String
    {
        get
        {
            return m_mode
        }
        
        set(newMode)
        {
            m_mode = newMode
        }
    }
    
    public var date: String
    {
        get
        {
            return m_date
        }
        
        set(newDate)
        {
            m_date = newDate
        }
    }
    
    // initializer (constructor)
    init(name: String, age:Int = 1, height: Double = 0.0, weight: Double = 0.0, category: String = "", mode: String = "", date: String = "")
    {
        m_name = name
        m_age = age
        m_height = height
        m_weight = weight
        m_category = category
        m_mode = mode
        m_date = date
        // generate random id based on date hashValue
        m_id = "\(abs(m_name.hashValue))"
    }
    
}

