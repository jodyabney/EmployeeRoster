
import UIKit

class EmployeeDetailTableViewController: UITableViewController, UITextFieldDelegate, EmployeeTypeDelegate {

    struct PropertyKeys {
        static let unwindToListIndentifier = "UnwindToListSegue"
    }
    
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var employeeTypeLabel: UILabel!
    
    
    @IBOutlet weak var dobDatePicker: UIDatePicker!
    
    let dobLabelIndexPath = IndexPath(row: 1, section: 0)
    let dobDataPickerIndexPath = IndexPath(row: 2, section: 0)
    
    var isEditingBirthday: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    var employee: Employee?
    
    var employeeType: EmployeeType?
    
    
    
    //MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    //MARK: - Instance Methods
    
    func updateView() {
        if let employee = employee {
            navigationItem.title = employee.name
            nameTextField.text = employee.name
            dobLabel.text = formatDate(date: employee.dateOfBirth)
            dobLabel.textColor = .black
            employeeTypeLabel.text = employee.employeeType.description()
            employeeTypeLabel.textColor = .black
        } else {
            navigationItem.title = "New Employee"
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    //MARK: - IBAction Methods
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let name = nameTextField.text, let type = employeeType {
            employee = Employee(name: name, dateOfBirth: dobDatePicker.date, employeeType: type)
            performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        employee = nil
        performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
    }
    
    
    @IBAction func datePickerDateChanged(_ sender: UIDatePicker) {
        
        dobLabel.text = formatDate(date: sender.date)
    }
    
    // MARK: - Text Field Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case dobDataPickerIndexPath:
            if isEditingBirthday == true {
                return dobDatePicker.frame.height
            } else {
                return 0
            }
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == dobLabelIndexPath {
            isEditingBirthday = !isEditingBirthday
            //dobLabel.textColor = .black
            
        }
    }
    
    //MARK: - Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? EmployeeTypeTableViewController
        destinationVC?.delegate = self
    }
    
    
    //MARK: - EmployeeType Delegate Methods
    
    func didSelect(employeeType: EmployeeType) {
        self.employeeType = employeeType
        employeeTypeLabel.text = employeeType.description()
        employeeTypeLabel.textColor = .black
        updateView()
    }

}
