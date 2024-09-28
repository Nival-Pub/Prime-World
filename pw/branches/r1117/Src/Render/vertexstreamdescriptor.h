#pragma once

namespace Render
{
	enum EVertexStreamType
	{
		VERTEX_STREAM_DEFAULT,
		VERTEX_STREAM_PERINSTANCEDATA,
		VERTEX_STREAM_COMMONINSTANCEDATA
	};

	/// �������� ������� ������ ���������� ������
	struct VertexStreamDescriptor
	{
	public:
		/// �����������
		VertexStreamDescriptor(): offset(0), stride(0), type(VERTEX_STREAM_DEFAULT), instancesCount(0) {}
		/// �����������
		VertexStreamDescriptor(unsigned int _offset, unsigned int _stride, EVertexStreamType _type = VERTEX_STREAM_DEFAULT, unsigned int _instancesCount = 0): 
			offset(_offset), stride(_stride), type(_type), instancesCount(_instancesCount) {}


		///
		VertexStreamDescriptor& operator = (const VertexStreamDescriptor& other)
		{
			type = other.type;
			offset = other.offset;
			stride = other.stride;
			instancesCount = other.instancesCount;

			return *this;
		}

		///
		bool operator == (const VertexStreamDescriptor& other) const
		{
			return type == other.type && offset == other.offset && stride == other.stride && instancesCount == other.instancesCount;
		}

		///
		bool operator != (const VertexStreamDescriptor& other) const { return !operator == (other); }

		/// ���
		EVertexStreamType type;
		/// ��������
		unsigned int offset;
		/// ������
		unsigned int stride;
		/// ���������� ���������
		unsigned int instancesCount;
	};
}; // namespace Render