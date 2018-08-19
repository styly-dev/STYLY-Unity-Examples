using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class CameraController : MonoBehaviour {

    readonly Vector3 lookAtPosition = new Vector3(0f, 1.5f, 0f );
    readonly Vector3 cameraPosition = new Vector3(0f, 1.5f, -5f);
    private  Vector3 velocity       = Vector3.zero;
    const float speed = 16f;
    const float lookAtSpeed = 8f;
    
    const   float MAX_DISTANCE      = 200f;

    private  GameObject center;
    private Camera     target;
    private Vector3    startPosition;
    private Vector3    movePosition;
    private Vector3    centerMovePosition;
    private Vector3    lastMouseDownPosition = Vector3.zero;

    private bool       pressedMouseButton = false;
    private bool       pressedMouseRightButton = false;
    private float      doubleClickTime;

    [SerializeField, Range(0.1f, 10f)]
    public float wheelSpeed = 3.0f;

    private bool isResetPos = false;
    private Rigidbody centerRigidbody;
    Vector3 Dist;

    
    void Start () {
        target = gameObject.GetComponent<Camera>();
        center = new GameObject("Center");
        center.transform.position = target.transform.position;

        target.transform.parent = center.transform;
//        target.transform.localPosition = cameraPosition;
        startPosition = target.transform.localPosition;
        movePosition = target.transform.position;

        center.AddComponent<Rigidbody>();
        centerRigidbody = center.GetComponent<Rigidbody>();
        centerRigidbody.angularDrag = 3f;
        centerRigidbody.useGravity = false;
    }
    
    void Update() {


        if (isResetPos)
        {
            center.transform.position = Vector3.MoveTowards(center.transform.position, lookAtPosition, 300f * Time.deltaTime);
            target.transform.position = Vector3.MoveTowards(target.transform.position, cameraPosition, 300f * Time.deltaTime);
            center.transform.rotation = Quaternion.RotateTowards(center.transform.rotation, Quaternion.Euler(0, 0, 0), 300f * Time.deltaTime);

            if (target.transform.position == cameraPosition && center.transform.position == lookAtPosition && center.transform.rotation == Quaternion.Euler(0, 0, 0))
            {
                isResetPos = false;
            }
            return;
        }

        if (Input.GetMouseButtonDown(0))
        {
            {
                pressedMouseButton = true;
                lastMouseDownPosition = Input.mousePosition;
            }
        }


        if (Input.GetMouseButtonUp(0))
        {
            pressedMouseButton = false;
            center.transform.RotateAround(center.transform.position, center.transform.right, -Dist.y * speed * Time.deltaTime);
            lastMouseDownPosition = Input.mousePosition;
        }

        if (Input.GetMouseButtonDown(1))
        {
            pressedMouseRightButton = true;
            lastMouseDownPosition = Input.mousePosition;
        }

        if (Input.GetMouseButtonUp(1))
        {
            pressedMouseRightButton = false;
        }

        if (pressedMouseButton)
        {
            Dist = Input.mousePosition - lastMouseDownPosition;
            center.transform.RotateAround(center.transform.position, Vector3.up, Dist.x * speed * Time.deltaTime);
            center.transform.RotateAround(center.transform.position, center.transform.right, -Dist.y * speed * Time.deltaTime);
            lastMouseDownPosition = Input.mousePosition;
        }
        else if (pressedMouseRightButton)
        {
            var diff = Input.mousePosition - lastMouseDownPosition;
            var vec = -diff / 100.0f;
            center.transform.Translate((Vector3.right * vec.x) + (Vector3.up * vec.y));
            lastMouseDownPosition = Input.mousePosition;
        }
        else
        {
            float scrollWheel = Input.GetAxis("Mouse ScrollWheel");
            if (scrollWheel != 0.0f)
            {
                MouseWheel(scrollWheel);
            }

        }


        if (Input.GetKeyDown(KeyCode.F))
        {
            ResetCameraPosition();
        }
    }

    private void MouseWheel(float delta)
    {
        Vector3 diff = center.transform.forward * delta * wheelSpeed;
        target.transform.position += diff;

        if( target.transform.localPosition.z >= 0)
        {
            // カメラが中心点を追い越した場合、centerを進めてカメラは0点にする。
            center.transform.position += center.transform.forward * (target.transform.localPosition.z);
            target.transform.localPosition = Vector3.zero;
        }

        return;
    }

    public void ResetCameraPosition()
    {
        isResetPos = true;
    }
    
}
